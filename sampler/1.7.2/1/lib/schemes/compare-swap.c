#include <pthread.h>
#include "compare-swap.h"
#include "samples.h"

/*modelled after function-entries*/

__thread int cbi_compareSwapSampling;
__thread int cbi_compareSwapCounter;


void cbi_compareSwapReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "compare-swap");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();

}

//dynamic dictionary
#define DYNAMIC_DICT


#ifdef DYNAMIC_DICT 

///TODO: shouldn't be here
#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
typedef unsigned long int ulint;


#define hashsize(n) ((unsigned int)1<<(n))
#define hashmask(n) (hashsize(n)-1)

#define N 10


#define DICT_FOUND 1
#define DICT_NOT_FOUND 0


inline unsigned int hash32shiftmult(unsigned int key)
{
  unsigned int c2=0x27d4eb2d; // a prime or an odd constant
  key = (key ^ 61) ^ (key >> 16);
  key = key + (key << 3);
  key = key ^ (key >> 4);
  key = key * c2;
  key = key ^ (key >> 15);
  // "key" contains the hash
  // We need only N bits
  key = (key & hashmask(N));
  return key;
}

inline ulint hash(ulint i)
{
  i += ~(i << 9);
  i ^=  ((i >> 14) | (i << 18)); /* >>> */
  i +=  (i << 4);
  i ^=  ((i >> 10) | (i << 22)); /* >>> */
    
  i = (i & hashmask(N)); //modulo power of 2
  return i;

}

//Robert Jenkin's 32 bit integer has function
inline unsigned int hash32( unsigned int a)
{
  a = (a+0x7ed55d16) + (a<<12);
  a = (a^0xc761c23c) ^ (a>>19);
  a = (a+0x165667b1) + (a<<5);
  a = (a+0xd3a2646c) ^ (a<<9);
  a = (a+0xfd7046c5) + (a<<3);
  a = (a^0xb55a4f09) ^ (a>>16);

  // "a" contains the hash
  // We need only N bits
  a = (a & hashmask(N));
  return a;
}


struct cbi_DictNode
{
  ulint key;
  ulint value;
  ulint generation;
  struct cbi_DictNode* next;
};

//static pthread_mutex_t tableLock __attribute__((unused)) = PTHREAD_MUTEX_INITIALIZER;

/* thread globals */
__thread struct cbi_DictNode *table[hashsize(N)];
__thread ulint numBuckets = hashsize(N);

__thread ulint count=0;

__thread ulint curGeneration = 3;
__thread ulint isInitialized = 0;

void cbi_dict_clear()
{
//  pthread_mutex_lock(&tableLock);
  curGeneration++;
//  pthread_mutex_unlock(&tableLock);

}


/* Initialize the hash buckets, if not already initialized*/
void cbi_dict_init_once()
{
  if(isInitialized==0)
    {
      ulint i=0;
      for(i=0;i<numBuckets;i++)
	table[i] = NULL;
      isInitialized=1;
    }
  return;
}

void cbi_dict_print()
{
  ulint i=0;
  for(i=0;i<100;i++)
    {
      struct cbi_DictNode *head = table[i];
      fprintf(stderr,"\n%lu : ",i);
      while(head!=NULL)
	{
	  fprintf(stderr,"(%lu->%lu(%lu)", head->key, head->value, head->generation);
	  head=head->next;
	}
    }
  fprintf(stderr,"\nCount %lu\n", count);
}

inline struct cbi_DictNode *newNode(ulint key, ulint value)
{
  struct cbi_DictNode *head = (struct cbi_DictNode*)malloc(sizeof(struct cbi_DictNode));
  if(!head)
    {
      fprintf(stderr, "CCI: Out of memory");
      return NULL;
    }
  count++; // Keep track of number of entries
  head->key = key;
  head->value = value;
  head->generation = curGeneration;
  head->next = NULL;
  return head;
}

void cbi_dict_insert(ulint key, ulint value)
{
  ulint bucket;
  struct cbi_DictNode *head;
  cbi_dict_init_once();
  bucket = hash(key);

  if(table[bucket]==NULL)
    {
      // Key not found; Bucket list is empty
      struct cbi_DictNode *temp = newNode(key, value);
      if(temp==NULL)
	return;
      table[bucket] = temp;
      return;
    }
  // Bucket list is not empty
  head = table[bucket];
  while(head != NULL && head->key != key ) //TODO: handle generation
    head = head->next;
  if(NULL==head)
    {
      // Key not found
      head = newNode(key, value);
      if(head==NULL) //out of memory
	return;
      head->next = table[bucket];  // Pointer shuffles
      table[bucket] = head;
      return;
    }
  assert(head->key==key); //already present
  {
    head->value = value;
    head->generation = curGeneration;
    return;
  }
}

int cbi_dict_lookup(ulint key, ulint *value)
{
  ulint bucket;
  struct cbi_DictNode *head;
  cbi_dict_init_once();
  bucket = hash(key);

  if(table[bucket]==NULL)
    {
      // Key not found; Bucket list is empty
      return DICT_NOT_FOUND;
    }
  // Bucket list is not empty
  head = table[bucket];
  while(head != NULL && head->key != key ) //TODO: handle generation
    head = head->next;
  if(head==NULL)
    return DICT_NOT_FOUND;
  assert(head->key==key); //already present
  {
    *value = head->value;
    return DICT_FOUND;
  }

}


int cbi_dict_lookup_insert(ulint key, ulint *oldVal, ulint newVal)
{
  ulint bucket;
  struct cbi_DictNode *head;
  cbi_dict_init_once();
  bucket = hash(key);

  if(table[bucket]==NULL)
    {
      // Key not found; Bucket list is empty
      struct cbi_DictNode *temp = newNode(key, newVal);
      if(temp==NULL) // out of memory
	return DICT_NOT_FOUND;
      table[bucket] = temp;
      return DICT_NOT_FOUND;
    }
  // Bucket list is not empty
  head = table[bucket];
  while(head != NULL && head->key != key ) //TODO: handle generation
    head = head->next;
  if(head==NULL)
    {
      // Key not found
      head = newNode(key, newVal);
      if(head==NULL)
	return DICT_NOT_FOUND;
      head->next = table[bucket];  // Pointer shuffles
      table[bucket] = head;

      return DICT_NOT_FOUND;
    }
  assert(head->key==key); //already present
  {
    *oldVal = head->value;
    head->value = newVal; //TODO: check the generation
    head->generation = curGeneration;
    return DICT_FOUND;
  }
}




int cbi_dict_test_and_insert(ulint key,
			     ulint expectedVal,
			     int *isDifferent,
			     int *isStale)
{
  ulint bucket;
  struct cbi_DictNode *head;
  cbi_dict_init_once();
  bucket = hash(key);

  *isDifferent=0; // default values
  *isStale=1;
  if(table[bucket]==NULL)
    {
      // Key not found; Bucket list is empty
      struct cbi_DictNode *temp = newNode(key, expectedVal);
      if(temp==NULL) // out of memory
	return DICT_NOT_FOUND;
      table[bucket] = temp;
      return DICT_NOT_FOUND;
    }
  // Bucket list is not empty
  head = table[bucket];
  while(head != NULL && head->key != key ) //TODO: handle generation
    head = head->next;
  if(head==NULL)
    {
      // Key not found
      head = newNode(key, expectedVal);
      if(head==NULL) //out of memory
	return DICT_NOT_FOUND;
      head->next = table[bucket];  // Insert to head of bucket list
      table[bucket] = head;
      return DICT_NOT_FOUND;
    }
  assert(head->key==key); //already present
  {
    *isDifferent = (head->value != expectedVal);
    *isStale = ( head->generation != curGeneration );
    head->value = expectedVal;
    head->generation = curGeneration;
    return DICT_FOUND;
  }
}


#endif //DYNAMIC_DICT



#ifndef DYNAMIC_DICT

//----------------------



//#include<assert.h>

#include <pthread.h>

#define hashsize(n) ((unsigned int)1<<(n))
#define hashmask(n) (hashsize(n)-1)

#define N 20

#define NUM_RETRY 20

#define DICT_FOUND 1
#define DICT_NOT_FOUND 0

struct cbi_DictNode
{
  unsigned int key;
  unsigned int value;
  unsigned int generation;
};

//static pthread_mutex_t tableLock __attribute__((unused)) = PTHREAD_MUTEX_INITIALIZER;

__thread struct cbi_DictNode dict[hashsize(N)];

__thread unsigned int curGeneration = 3;
__thread unsigned int isInitialized = 0;

void cbi_dict_clear()
{
  //TODO: lock or atomic update
//  pthread_mutex_lock(&tableLock);
  curGeneration++;
//  pthread_mutex_unlock(&tableLock);   //unlock

}

unsigned int hash32shiftmult(unsigned int key)
{
  unsigned int c2=0x27d4eb2d; // a prime or an odd constant
  key = (key ^ 61) ^ (key >> 16);
  key = key + (key << 3);
  key = key ^ (key >> 4);
  key = key * c2;
  key = key ^ (key >> 15);
   // "key" contains the hash
   // We need only N bits
   key = (key & hashmask(N));
  return key;
}


//Robert Jenkin's 32 bit integer has function
unsigned int hash32( unsigned int a)
{
   a = (a+0x7ed55d16) + (a<<12);
   a = (a^0xc761c23c) ^ (a>>19);
   a = (a+0x165667b1) + (a<<5);
   a = (a+0xd3a2646c) ^ (a<<9);
   a = (a+0xfd7046c5) + (a<<3);
   a = (a^0xb55a4f09) ^ (a>>16);

   // "a" contains the hash
   // We need only N bits
   a = (a & hashmask(N));
   return a;
}

//macro to determine if the current node is deleted
#define valid(n) (dict[n].generation == curGeneration)
#define isCurrentGen(n) (dict[n].generation == curGeneration)
#define INVALID_KEY (0)
#define isEmpty(n) (dict[n].key == INVALID_KEY)

//#define USE_LOCK 1
//open addressing with linear chaining
unsigned int cbi_dict_insert(unsigned int key, unsigned int val)
{


  unsigned int last;
  unsigned int i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
  //assert( last < hashsize(N) );
  //lock
#ifdef USE_LOCK
//  pthread_mutex_lock(&tableLock);
#endif
  while( i != last && valid(i) && dict[i].key != key)
    i = (i+1) & hashmask(N);
  if( !valid(i) || dict[i].key == key )
    {
      dict[i].key = key;
      dict[i].value = val;
      dict[i].generation = curGeneration;
#ifdef USE_LOCK
//  pthread_mutex_unlock(&tableLock);
#endif
      //unlock
      return 1;
    }
  else
    {
      //unlock
#ifdef USE_LOCK
//      pthread_mutex_unlock(&tableLock);
#endif
      // Didn't find a slot; ignore error
      return 0;
    }
}


int cbi_dict_lookup(unsigned int key, unsigned int *val)
{

  unsigned int i;
  unsigned int last;
  i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
  //assert( last < hashsize(N) );

#ifdef USE_LOCK
//  pthread_mutex_lock(&tableLock);
#endif
  while( i!=last && valid(i) && dict[i].key!=key)
    i=(i+1) & hashmask(N);
  if(valid(i))
    {
      *val = dict[i].value;
#ifdef USE_LOCK
//      pthread_mutex_unlock(&tableLock);
#endif
      return DICT_FOUND;
    }
#ifdef USE_LOCK
//  pthread_mutex_unlock(&tableLock);
#endif
  // Didn't find a slot; ignore error
  return DICT_NOT_FOUND;
}


 
/* arguments:
   key: the key to perform the lookup
   expected: the expected value to compare with and value used to set
   isDifferent: is set to 1 if the value found in the hashtable differs from the expected value passed, 0 otherwise
   isStale: if 1 if the current value refers to a previous generation, 0 otherwise
 */



void cbi_dict_test_and_set(unsigned int key,
			   unsigned int expectedVal,
			   int *isDifferent,
			   int *isStale)
{
  unsigned int i=0;
  unsigned int last=0;
  unsigned int deletedIndex=0;
  unsigned int foundDeleted =0;
  unsigned int count =0;
  if(!isInitialized)
    {
#ifdef USE_LOCK
//      pthread_mutex_lock(&tableLock);
#endif
      for(i=0;i<hashsize(N); i++)
	dict[i].key = INVALID_KEY;
      isInitialized =1;
#ifdef USE_LOCK
 //     pthread_mutex_unlock(&tableLock);
#endif
    }
  i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
#ifdef USE_LOCK
//  pthread_mutex_lock(&tableLock);
#endif
  foundDeleted =0;
  count =0;
  while( /* count!=NUM_RETRY && */ i!=last && !isEmpty(i) && dict[i].key!=key) /* skip over entries marked deleted i.e. from a previous generation */
    {
      /* keep track of the first entry marked deleted i.e. not the current generation */
      if(!isCurrentGen(i) && !foundDeleted ) { foundDeleted =1; deletedIndex = i; }
      i=(i+1) & hashmask(N);
      //count++;
    }
  if(dict[i].key==key) /*found key; replace with current value */
    {
      *isDifferent = (dict[i].value != expectedVal);
      *isStale = !isCurrentGen(i);
      dict[i].key = key;
      dict[i].value = expectedVal;
      dict[i].generation = curGeneration;

    }
  else if(isEmpty(i)) /* first time entry */
    {
      *isDifferent =0;
      *isStale = 1;
      dict[i].key = key;
      dict[i].value = expectedVal;
      dict[i].generation = curGeneration;
	  
    }
  else //if(i==last || count==NUM_RETRY) /*not found*/
    {
      *isDifferent = 0;
      *isStale = 1;
      if(foundDeleted)/* replace the first entry marked deleted */
	{
	  dict[deletedIndex].key = key;
	  dict[deletedIndex].value = expectedVal;
	  dict[deletedIndex].generation = curGeneration;
	}
      else /* replace last position */
	{
	  //	  i = hash32(key);
	  dict[i].key = key;
	  dict[i].value = expectedVal;
	  dict[i].generation = curGeneration;

	}
    }

#ifdef USE_LOCK
//  pthread_mutex_unlock(&tableLock);
#endif
  return;

}
#endif

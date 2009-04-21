#include "atoms.h"
#include "samples.h"

/*modelled after function-entries*/

static pthread_mutex_t atomsLock __attribute__((unused)) = PTHREAD_MUTEX_INITIALIZER;

void cbi_atomsReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "atoms");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();

}
//cleanup: 
int cbi_thread_self()
{
  int temp = pthread_self();
  return temp;
}

void cbi_atoms_yield()
{
  sched_yield();
}

void cbi_atoms_lock()
{
  pthread_mutex_lock(&atomsLock);
}


void cbi_atoms_unlock()
{
  pthread_mutex_unlock(&atomsLock);
}


///TODO: shouldn't be here

//#include<assert.h>

#include <pthread.h>

#define hashsize(n) ((unsigned int)1<<(n))
#define hashmask(n) (hashsize(n)-1)

#define N 10

#define NUM_RETRY 20

#define DICT_FOUND 1
#define DICT_NOT_FOUND 0

struct cbi_DictNode
{
  unsigned int key;
  unsigned int value;
  unsigned int generation;
};

static pthread_mutex_t tableLock __attribute__((unused)) = PTHREAD_MUTEX_INITIALIZER;

struct cbi_DictNode dict[hashsize(N)];

unsigned int curGeneration = 3;
unsigned int isInitialized = 0;

void cbi_dict_clear()
{
  //TODO: lock or atomic update
  pthread_mutex_lock(&tableLock);
  curGeneration++;
  pthread_mutex_unlock(&tableLock);   //unlock

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

#define USE_LOCK 1
//open addressing with linear chaining
unsigned int cbi_dict_insert(unsigned int key, unsigned int val)
{


  unsigned int last;
  unsigned int i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
  //assert( last < hashsize(N) );
  //lock
#ifdef USE_LOCK
  pthread_mutex_lock(&tableLock);
#endif
  while( i != last && valid(i) && dict[i].key != key)
    i = (i+1) & hashmask(N);
  if( !valid(i) || dict[i].key == key )
    {
      dict[i].key = key;
      dict[i].value = val;
      dict[i].generation = curGeneration;
#ifdef USE_LOCK
  pthread_mutex_unlock(&tableLock);
#endif
      //unlock
      return 1;
    }
  else
    {
      //unlock
#ifdef USE_LOCK
      pthread_mutex_unlock(&tableLock);
#endif
      // Didn't find a slot; ignore error
      return 0;
    }
}


unsigned int cbi_dict_lookup(unsigned int key, unsigned int *val)
{

  unsigned int i;
  unsigned int last;
  i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
  //assert( last < hashsize(N) );

#ifdef USE_LOCK
  pthread_mutex_lock(&tableLock);
#endif
  while( i!=last && valid(i) && dict[i].key!=key)
    i=(i+1) & hashmask(N);
  if(valid(i))
    {
      *val = dict[i].value;
#ifdef USE_LOCK
      pthread_mutex_unlock(&tableLock);
#endif
      return DICT_FOUND;
    }
#ifdef USE_LOCK
  pthread_mutex_unlock(&tableLock);
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
			   unsigned int *isDifferent,
			   unsigned int *isStale)
{
  unsigned int i=0;
  unsigned int last=0;
  unsigned int deletedIndex=0;
  unsigned int foundDeleted =0;
  unsigned int count =0;
  if(!isInitialized)
    {
#ifdef USE_LOCK
      pthread_mutex_lock(&tableLock);
#endif
      for(i=0;i<hashsize(N); i++)
	dict[i].key = INVALID_KEY;
      isInitialized =1;
#ifdef USE_LOCK
      pthread_mutex_unlock(&tableLock);
#endif
    }
  i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
#ifdef USE_LOCK
  pthread_mutex_lock(&tableLock);
#endif
  foundDeleted =0;
  count =0;
  while( count!=NUM_RETRY && i!=last && !isEmpty(i) && dict[i].key!=key) /* skip over entries marked deleted i.e. from a previous generation */
    {
      /* keep track of the first entry marked deleted i.e. not the current generation */
      if(!isCurrentGen(i) && !foundDeleted ) { foundDeleted =1; deletedIndex = i; }
      i=(i+1) & hashmask(N);
      count++;
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
      *isStale = 0;
      dict[i].key = key;
      dict[i].value = expectedVal;
      dict[i].generation = curGeneration;
	  
    }
  else if(i==last || count==NUM_RETRY) /*not found; replace the first entry marked deleted */
    {
      *isDifferent = 0;
      *isStale = 0;
      if(foundDeleted)
	{
	  dict[deletedIndex].key = key;
	  dict[deletedIndex].value = expectedVal;
	  dict[deletedIndex].generation = curGeneration;
	}
    }

#ifdef USE_LOCK
  pthread_mutex_unlock(&tableLock);
#endif
  return;

}

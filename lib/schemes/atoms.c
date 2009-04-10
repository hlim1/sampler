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

//open addressing with linear chaining
unsigned int cbi_dict_insert(unsigned int key, unsigned int val)
{


  unsigned int last;
  unsigned int i = hash32(key);
  last = (i+hashsize(N)-1 ) & hashmask(N);
  //assert( last < hashsize(N) );
  //TODO: lock
  pthread_mutex_lock(&tableLock);
  while( i != last && valid(i) && dict[i].key != key)
    i = (i+1) & hashmask(N);
  if( !valid(i) || dict[i].key == key )
    {
      dict[i].key = key;
      dict[i].value = val;
      dict[i].generation = curGeneration;
  pthread_mutex_unlock(&tableLock);
      //unlock
      return 1;
    }
  else
    {
      //unlock
      pthread_mutex_unlock(&tableLock);
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

  //TODO: lock
  pthread_mutex_lock(&tableLock);
  while( i!=last && valid(i) && dict[i].key!=key)
    i=(i+1) & hashmask(N);
  if(valid(i))
    {
      *val = dict[i].value;
  pthread_mutex_unlock(&tableLock);
      //unlock
      return DICT_FOUND;
    }
  //unlock
  pthread_mutex_unlock(&tableLock);
  // Didn't find a slot; ignore error
  return DICT_NOT_FOUND;
}
 

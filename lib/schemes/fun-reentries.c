#include "fun-reentries.h"
#include "samples.h"
#include "tuple-2.h"

static pthread_mutex_t funreLock __attribute__((unused)) = PTHREAD_MUTEX_INITIALIZER;

void cbi_funReentriesReport(const cbi_UnitSignature signature,
			       unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "fun-reentries");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();
}


void cbi_funre_lock()
{
  pthread_mutex_lock(&funreLock);
}


void cbi_funre_unlock()
{
  pthread_mutex_unlock(&funreLock);
}

void cci_atomicIncrementCounter(int *counter)
{
#if __i386__
  asm ("lock incl %0"
       : "+m" (*counter)
       :
       : "cc");
#else
#error "don't know how to atomically increment on this architecture"
#endif
}

void cci_atomicDecrementCounter(int *counter)
{
#if __i386__
  asm ("lock decl %0"
       : "+m" (*counter)
       :
       : "cc");
#else
#error "don't know how to atomically increment on this architecture"
#endif
}

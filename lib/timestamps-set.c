#define _GNU_SOURCE    /* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "timestamps.h"


samplerTimestamp samplerClock;

#ifdef SAMPLER_THREADS
pthread_mutex_t clockLock = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;
#endif /* threads */


void timestampsSetFirst(unsigned site, samplerTimestamp first[])
{
  CRITICAL_REGION(clockLock, {
    ++samplerClock;
    if (!first[site]) first[site] = samplerClock;
  });
}


void timestampsSetLast(unsigned site, samplerTimestamp last[])
{
  CRITICAL_REGION(clockLock, {
    ++samplerClock;
    last[site] = samplerClock;
  });
}


void timestampsSetBoth(unsigned site, samplerTimestamp first[], samplerTimestamp last[])
{
  CRITICAL_REGION(clockLock, {
    ++samplerClock;
    if (!first[site]) first[site] = samplerClock;
    last[site] = samplerClock;
  });
}

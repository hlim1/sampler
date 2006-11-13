#define _GNU_SOURCE    /* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../timestamps.h"


cbi_Timestamp cbi_clock;

pthread_mutex_t cbi_clockLock = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;


void cbi_timestampsSetFirst(unsigned site, cbi_Timestamp first[])
{
  CBI_CRITICAL_REGION(cbi_clockLock, {
    ++cbi_clock;
    if (!first[site]) first[site] = cbi_clock;
  });
}


void cbi_timestampsSetLast(unsigned site, cbi_Timestamp last[])
{
  CBI_CRITICAL_REGION(cbi_clockLock, {
    ++cbi_clock;
    last[site] = cbi_clock;
  });
}


void cbi_timestampsSetBoth(unsigned site, cbi_Timestamp first[], cbi_Timestamp last[])
{
  CBI_CRITICAL_REGION(cbi_clockLock, {
    ++cbi_clock;
    if (!first[site]) first[site] = cbi_clock;
    last[site] = cbi_clock;
  });
}

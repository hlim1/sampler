#include "clock-threads.h"
#include "lock.h"


static pthread_mutex_t clockLock = PTHREAD_MUTEX_INITIALIZER;
static unsigned samplerClock;


void samplerClockTick(unsigned *timestamp)
{
  CRITICAL_REGION(clockLock, {
    *timestamp = ++samplerClock;
  });
}

#include <limits.h>
#include "cyclic.h"
#include "event.h"


const unsigned *nextEventPrecomputed = 0;
unsigned nextEventCountdown = UINT_MAX;
unsigned nextEventSlot = 0;


__attribute__((constructor)) static void initialize()
{
  nextEventPrecomputed = loadCountdowns("SAMPLER_EVENT_COUNTDOWNS");
  nextEventCountdown = getNextEventCountdown();
}


__attribute__((destructor)) static void shutdown()
{
  unloadCountdowns(nextEventPrecomputed);
}

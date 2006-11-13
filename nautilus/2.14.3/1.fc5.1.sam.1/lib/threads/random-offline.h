#ifndef INCLUDE_sampler_random_offline_h
#define INCLUDE_sampler_random_offline_h

#include "local.h"
#include "random-offline-size.h"


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_exclude_function("getNextEventCountdown")
#endif


#define SAMPLER_FEATURE_RANDOM samplerFeatureRandomOffline


static inline int getNextEventCountdown()
{
  extern const int *nextEventPrecomputed;
  extern SAMPLER_THREAD_LOCAL unsigned nextEventSlot;

  unsigned slot = nextEventSlot;
  const int result = nextEventPrecomputed[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextEventSlot = slot;
  return result;
}


#endif /* !INCLUDE_sampler_random_offline_h */

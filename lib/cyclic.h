#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h

#include "cyclic-size.h"


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_exclude_function("getNextEventCountdown")
#endif

static inline int getNextEventCountdown()
{
  extern const int *nextEventPrecomputed;
  extern unsigned nextEventSlot;

  unsigned slot = nextEventSlot;
  const int result = nextEventPrecomputed[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextEventSlot = slot;
  return result;
}


#endif /* !INCLUDE_libcountdown_cyclic_h */

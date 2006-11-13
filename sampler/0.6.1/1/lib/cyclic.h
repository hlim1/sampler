#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h

#include "cyclic-size.h"


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_exclude_function("getNextEventCountdown")
#endif

static inline unsigned getNextEventCountdown()
{
  extern const unsigned *nextEventPrecomputed;
  extern unsigned nextEventSlot;

  unsigned slot = nextEventSlot;
  const unsigned result = nextEventPrecomputed[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextEventSlot = slot;
  return result;
}


#endif /* !INCLUDE_libcountdown_cyclic_h */

#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h

#include "cyclic-size.h"


extern const void * const SAMPLER_REENTRANT(providesLibCyclic);

#ifdef CIL
#pragma cilnoremove("requiresLibCyclic")
#pragma cilnoremove("requiresLibCyclic_r")
static const void * const SAMPLER_REENTRANT(requiresLibCyclic) = &SAMPLER_REENTRANT(providesLibCyclic);
#endif


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

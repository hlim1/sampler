#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h

#include "cyclic-size.h"


static inline unsigned getNextEventCountdown() __attribute__((no_instrument_function));

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

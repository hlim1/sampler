#ifndef INCLUDE_libcountdown_event_h
#define INCLUDE_libcountdown_event_h

#include "cyclic-size.h"


extern const unsigned *nextEventPrecomputed;
extern unsigned nextEventCountdown;
extern unsigned nextEventSlot;


static inline unsigned getNextEventCountdown() __attribute__((no_instrument_function));

static inline unsigned getNextEventCountdown()
{
  unsigned slot = nextEventSlot;
  const unsigned result = nextEventPrecomputed[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextEventSlot = slot;
  return result;
}


#endif /* !INCLUDE_libcountdown_event_h */

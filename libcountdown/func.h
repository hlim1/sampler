#ifndef INCLUDE_libcountdown_func_h
#define INCLUDE_libcountdown_func_h

#include "cyclic.h"
#include "cyclic-size.h"


extern const unsigned *nextFuncPrecomputed;
extern unsigned nextFuncCountdown;
extern unsigned nextFuncSlot;


static inline unsigned getNextFuncCountdown() __attribute__((no_instrument_function));

static inline unsigned getNextFuncCountdown()
{
  unsigned slot = nextFuncSlot;
  const unsigned result = nextFuncPrecomputed[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextFuncSlot = slot;
  return result;
}


#endif /* !INCLUDE_libcountdown_func_h */

#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h


#define PRECOMPUTE_COUNT 1024


static inline unsigned getNextCountdown() __attribute__((no_instrument_function));

static inline unsigned getNextCountdown()
{
  extern unsigned nextCountdownSlot;
  extern const unsigned *precomputedCountdowns;

  unsigned slot = nextCountdownSlot;
  const unsigned result = precomputedCountdowns[slot];
  slot = (slot + 1) % PRECOMPUTE_COUNT;
  nextCountdownSlot = slot;
  return result;
}


#endif /* !INCLUDE_libcountdown_cyclic_h */

#ifndef INCLUDE_libcountdown_cyclic_h
#define INCLUDE_libcountdown_cyclic_h


#define PRECOMPUTE_COUNT 1024


static inline unsigned getNextCountdown()
{
  extern unsigned nextCountdownSlot;
  extern unsigned precomputedCountdowns[];

  const unsigned result = precomputedCountdowns[nextCountdownSlot];
  nextCountdownSlot = (nextCountdownSlot + 1) % PRECOMPUTE_COUNT;
  return result;
}


#endif /* !INCLUDE_libcountdown_cyclic_h */

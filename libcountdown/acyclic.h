#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


extern const void * const providesLibAcyclic;

#ifdef CIL
#pragma cilnoremove("requiresLibAcyclic")
static const void * const requiresLibAcyclic = &providesLibAcyclic;
#endif


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#endif

static inline unsigned getNextEventCountdown() __attribute__((no_instrument_function));

static inline unsigned getNextEventCountdown()
{
  extern double density;
  extern void *generator;
  extern unsigned gsl_ran_geometric();

  return generator ? gsl_ran_geometric(generator, density) : (unsigned) -1;
}


#endif /* !INCLUDE_libcountdown_acyclic_h */

#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


static inline unsigned getNextEventCountdown() __attribute__((no_instrument_function));

static inline unsigned getNextEventCountdown()
{
  extern double density;
  extern void *generator;
  extern unsigned gsl_ran_geometric();

  return generator ? gsl_ran_geometric(generator, density) : (unsigned) -1;
}


#endif /* !INCLUDE_libcountdown_acyclic_h */

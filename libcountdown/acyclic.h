#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


extern const void * const providesLibAcyclic;

#ifdef CIL
#pragma cilnoremove("requiresLibAcyclic")
static const void * const requiresLibAcyclic = &providesLibAcyclic;
#endif


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_exclude_function("getNextEventCountdown")
#pragma sampler_assume_weightless("gsl_ran_geometric")
#endif

static inline unsigned getNextEventCountdown()
{
  extern double acyclicDensity;
  extern void *acyclicGenerator;
  extern unsigned gsl_ran_geometric();

  if (__builtin_expect(!acyclicGenerator, 0))
    return (unsigned) -1;
  else
    return gsl_ran_geometric(acyclicGenerator, acyclicDensity);
}


#endif /* !INCLUDE_libcountdown_acyclic_h */

#ifndef INCLUDE_libcountdown_countdown_h
#define INCLUDE_libcountdown_countdown_h

#include <gsl/gsl_randist.h>


extern unsigned nextEventCountdown;


extern double density;
extern gsl_rng *generator;

inline unsigned getNextCountdown()
{
  return gsl_ran_geometric(generator, density);
}


#endif /* !INCLUDE_libcountdown_countdown_h */

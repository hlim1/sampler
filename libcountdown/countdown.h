#ifndef INCLUDE_libcountdown_countdown_h
#define INCLUDE_libcountdown_countdown_h


extern unsigned nextEventCountdown;


inline unsigned getNextCountdown()
{
  extern double density;
  extern void *generator;
  extern unsigned gsl_ran_geometric();

  return gsl_ran_geometric(generator, density);
}


#endif /* !INCLUDE_libcountdown_countdown_h */

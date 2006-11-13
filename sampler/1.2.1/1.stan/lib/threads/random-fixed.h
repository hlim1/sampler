#ifndef INCLUDE_libcountdown_random_fixed_h
#define INCLUDE_libcountdown_random_fixed_h


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_exclude_function("getNextEventCountdown")
#endif


#define SAMPLER_FEATURE_RANDOM samplerFeatureRandomFixed


static inline int getNextEventCountdown()
{
  extern int randomFixedCountdown;
  return randomFixedCountdown;
}


#endif /* !INCLUDE_libcountdown_random_fixed_h */

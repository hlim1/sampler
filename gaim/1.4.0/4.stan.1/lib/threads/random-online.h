#ifndef INCLUDE_libcountdown_random_online_h
#define INCLUDE_libcountdown_random_online_h


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_assume_weightless("getNextEventCountdown")
#endif


#define SAMPLER_FEATURE_RANDOM samplerFeatureRandomOnline


int getNextEventCountdown(void);


#endif /* !INCLUDE_libcountdown_random_online_h */

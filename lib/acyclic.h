#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_assume_weightless("getNextEventCountdown")
#endif

int getNextEventCountdown();


#endif /* !INCLUDE_libcountdown_acyclic_h */

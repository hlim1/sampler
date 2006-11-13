#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_assume_weightless("getNextEventCountdown")
#endif

unsigned getNextEventCountdown();


#endif /* !INCLUDE_libcountdown_acyclic_h */

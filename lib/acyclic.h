#ifndef INCLUDE_libcountdown_acyclic_h
#define INCLUDE_libcountdown_acyclic_h


extern const void * const SAMPLER_REENTRANT(providesLibAcyclic);

#ifdef CIL
#pragma cilnoremove("requiresLibAcyclic")
#pragma cilnoremove("requiresLibAcyclic_r")
static const void * const SAMPLER_REENTRANT(requiresLibAcyclic) = &SAMPLER_REENTRANT(providesLibAcyclic);
#endif


#ifdef CIL
#pragma cilnoremove("getNextEventCountdown")
#pragma sampler_assume_weightless("getNextEventCountdown")
#endif

unsigned getNextEventCountdown();


#endif /* !INCLUDE_libcountdown_acyclic_h */

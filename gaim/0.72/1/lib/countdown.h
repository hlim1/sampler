#ifndef INCLUDE_libcountdown_countdown_h
#define INCLUDE_libcountdown_countdown_h


extern SAMPLER_THREAD_LOCAL unsigned nextEventCountdown;


#ifdef CIL
#pragma cilnoremove("nextEventCountdown")
#endif


#endif /* !INCLUDE_libcountdown_countdown_h */

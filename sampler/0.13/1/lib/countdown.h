#ifndef INCLUDE_libcountdown_countdown_h
#define INCLUDE_libcountdown_countdown_h


#include "threads.h"


extern SAMPLER_THREAD_LOCAL int nextEventCountdown;


#ifdef CIL
#pragma cilnoremove("nextEventCountdown")
#endif


#endif /* !INCLUDE_libcountdown_countdown_h */

#ifndef INCLUDE_sampler_clock_h
#define INCLUDE_sampler_clock_h

#include "threads.h"


extern SAMPLER_THREAD_LOCAL unsigned samplerClock;


#ifdef CIL
#pragma cilnoremove("samplerClock")
#endif


#endif /* !INCLUDE_sampler_clock_h */

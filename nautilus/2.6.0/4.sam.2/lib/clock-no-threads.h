#ifndef INCLUDE_sampler_clock_no_threads_h
#define INCLUDE_sampler_clock_no_threads_h


extern unsigned samplerClock;

#ifdef CIL
#pragma cilnoremove("samplerClock")
#endif /* CIL */


#endif /* !INCLUDE_sampler_clock_no_threads_h */

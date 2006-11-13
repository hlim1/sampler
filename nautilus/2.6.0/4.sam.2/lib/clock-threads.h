#ifndef INCLUDE_sampler_clock_threads_h
#define INCLUDE_sampler_clock_threads_h


extern void samplerClockTick(unsigned *);

#ifdef CIL
#pragma cilnoremove("samplerClockTick")
#endif /* CIL */


#endif /* !INCLUDE_sampler_clock_threads_h */

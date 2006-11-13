#ifndef INCLUDE_sampler_clock_h
#define INCLUDE_sampler_clock_h

#ifdef SAMPLER_THREADS
#include "clock-threads.h"
#else  /* no threads */
#include "clock-no-threads.h"
#endif /* no threads */

#endif /* !INCLUDE_sampler_clock_h */

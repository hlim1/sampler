#ifndef INCLUDE_sampler_timestamps_h
#define INCLUDE_sampler_timestamps_h


#ifdef SAMPLER_TIMESTAMPS

#include "clock.h"
#include "threads.h"

#define SAMPLER_TIMESTAMP_FIELD unsigned timestamp

#else  /* no timestamps */

#define SAMPLER_TIMESTAMP_FIELD

#endif /* no timestamps */


#endif /* !INCLUDE_sampler_timestamps_h */

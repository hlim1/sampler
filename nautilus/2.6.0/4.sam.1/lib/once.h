#ifndef INCLUDE_sampler_once_h
#define INCLUDE_sampler_once_h

#ifdef SAMPLER_THREADS
#  include "once-threads.h"
#else  /* no threads */
#  include "once-no-threads.h"
#endif /* no threads */

#endif /* !INCLUDE_sampler_once_h */

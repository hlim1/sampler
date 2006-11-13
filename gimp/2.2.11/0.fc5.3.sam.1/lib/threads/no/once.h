#ifndef INCLUDE_sampler_once_no_threads_h
#define INCLUDE_sampler_once_no_threads_h

#include <pthread.h>


typedef int sampler_once_t;

#define SAMPLER_ONCE_INIT 0


static inline void sampler_once(sampler_once_t *control, void (*routine)())
{
  if (!*control)
    {
      *control = 1;
      routine();
    }
}


#endif // !INCLUDE_sampler_once_no_threads_h

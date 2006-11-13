#ifndef INCLUDE_sampler_once_threads_h
#define INCLUDE_sampler_once_threads_h

#include <pthread.h>


typedef pthread_once_t sampler_once_t;

#define SAMPLER_ONCE_INIT PTHREAD_ONCE_INIT


static inline void sampler_once(sampler_once_t *control, void (*routine)())
{
  pthread_once(control, routine);
}


#endif // !INCLUDE_sampler_once_threads_h

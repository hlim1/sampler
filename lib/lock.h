#ifndef INCLUDE_lib_lock_h
#define INCLUDE_lib_lock_h

#ifdef SAMPLER_THREADS
#include <pthread.h>
#include <stdio.h>
#include <string.h>


#define CRITICAL_REGION(mutex, block)							\
do {											\
  int lockError;									\
  pthread_cleanup_push((void (*)(void *)) pthread_mutex_unlock, (void *) &mutex);	\
  lockError = pthread_mutex_lock(&mutex);						\
  if (lockError)									\
    {											\
      char buffer[128];									\
      char * const message = strerror_r(lockError, buffer, sizeof(buffer));		\
      fprintf(stderr, "warning: %s failed to acquire mutex: %s\n", __func__, message);	\
    }											\
											\
  do block while(0);									\
											\
  pthread_cleanup_pop(!lockError);							\
} while(0)


#else  /* no threads */
#define CRITICAL_REGION(lock, block)  do block while(0)
#endif /* no threads */


#endif /* !INCLUDE_lib_lock_h */

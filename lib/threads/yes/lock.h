#ifndef INCLUDE_lib_lock_h
#define INCLUDE_lib_lock_h

#include <pthread.h>
#include <stdio.h>
#include <string.h>


#define CBI_CRITICAL_REGION(mutex, block)						\
do {											\
  int lockError;									\
  _Pragma("GCC diagnostic push")							\
  _Pragma("GCC diagnostic ignored \"-Wpragmas\"")					\
  _Pragma("GCC diagnostic ignored \"-Wcast-function-type\"")				\
  pthread_cleanup_push((void (*)(void *)) pthread_mutex_unlock, &mutex);		\
  _Pragma("GCC diagnostic pop")								\
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


#endif /* !INCLUDE_lib_lock_h */

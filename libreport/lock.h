#ifndef INCLUDE_libreport_lock_h
#define INCLUDE_libreport_lock_h

#ifdef SAMPLER_THREADS
#include <pthread.h>
#include <stdio.h>
#include <string.h>

extern pthread_mutex_t reportLock;

#define CRITICAL_REGION(block)								\
do {											\
  pthread_cleanup_push((void (*)(void *)) pthread_mutex_unlock, (void *) &reportLock);	\
  const int reportLockError = pthread_mutex_lock(&reportLock);				\
  if (reportLockError)									\
    {											\
      char buffer[128];									\
      char * const message = strerror_r(reportLockError, buffer, sizeof(buffer));	\
      fprintf(stderr, "warning: %s failed to acquire mutex: %s\n", __func__, message);	\
    }											\
											\
  do block while(0);									\
											\
  pthread_cleanup_pop(!reportLockError);						\
} while(0)


#else  /* no threads */
#define CRITICAL_REGION(block) block
#endif /* no threads */


#endif /* !INCLUDE_libreport_lock_h */

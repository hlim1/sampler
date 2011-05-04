#define _GNU_SOURCE /* For RTLD_NEXT */

#include <dlfcn.h>
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lifetime.h"


typedef void * (*Starter)(void *);


typedef struct Closure
{
  Starter start;
  void *argument;
} Closure;


static void *starter(Closure *closure)
{
  const Starter start = closure->start;
  void * const argument = closure->argument;
  free(closure);

  cbi_initialize_thread();
  return start(argument);
}

int pthread_create(pthread_t *thread,
		   const pthread_attr_t *attributes,
		   Starter start, void *argument)
{
  static typeof(pthread_create) *real_pthread_create;
  if(!real_pthread_create)
    real_pthread_create = dlsym(RTLD_NEXT, __func__);

  Closure * const closure = (Closure *) malloc(sizeof(Closure));
  if (!closure)
    {
      errno = ENOMEM;
      return -1;
    }

  closure->start = start;
  closure->argument = argument;
  return real_pthread_create(thread, attributes, (Starter) starter, closure);
}

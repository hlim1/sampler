#define _GNU_SOURCE		/* for RTLD_NEXT in <dlfcn.h> */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "countdown.h"
#include "lifetime.h"

#ifdef SAMPLER_CYCLIC
#include "cyclic.h"
#endif

#ifdef SAMPLER_ACYCLIC
#include "acyclic.h"
#endif


typedef void * (*Starter)(void *);


typedef struct Closure
{
  Starter start;
  void *argument;
} Closure;


static void *starter(Closure *closure)
{
  void *result;
  const Starter start = closure->start;
  void * const argument = closure->argument;
  free(closure);

  pthread_cleanup_push(finalize_thread, 0);
  initialize_thread();

  result = start(argument);
  pthread_cleanup_pop(1);
  return result;
}


typeof(pthread_create) __real_pthread_create;
typeof(pthread_create) __wrap_pthread_create;

int __wrap_pthread_create(pthread_t *thread,
			  const pthread_attr_t *attributes,
			  Starter start, void *argument)
{
  Closure * const closure = (Closure *) malloc(sizeof(Closure));
  if (!closure) return -1;

  closure->start = start;
  closure->argument = argument;
  return __real_pthread_create(thread, attributes, (Starter) starter, closure);
}

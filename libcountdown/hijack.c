#define _GNU_SOURCE		/* for RTLD_NEXT in <dlfcn.h> */

#include <dlfcn.h>
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

typedef int (*Creator)(pthread_t *, const pthread_attr_t *, Starter, void *);


typedef struct Closure
{
  Starter start;
  void *argument;
} Closure;


static void *starter(Closure *closure)
{
  void *result;
  pthread_cleanup_push(finalize_thread, 0);
  initialize_thread();

  const Starter start = closure->start;
  void * const argument = closure->argument;
  free(closure);

  result = start(argument);
  pthread_cleanup_pop(1);
  return result;
}


int pthread_create(pthread_t * __restrict thread,
		   const pthread_attr_t * __restrict attributes,
		   Starter start, void * __restrict argument)
{
  static Creator next;
  if (!next)
    {
      next = (Creator) dlsym(RTLD_NEXT, __func__);
      if (dlerror()) return -1;
      if (!next) return -1;
      if (next == pthread_create) return -1;
    }

  Closure * const closure = (Closure *) malloc(sizeof(Closure));
  if (!closure) return -1;

  closure->start = start;
  closure->argument = argument;
  return next(thread, attributes, (Starter) starter, closure);
}

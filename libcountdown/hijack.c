#define _GNU_SOURCE		/* for RTLD_NEXT in <dlfcn.h> */

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include "countdown.h"

#ifdef SAMPLER_CYCLIC
#include "cyclic.h"
#endif

#ifdef SAMPLER_ACYCLIC
#include "acyclic.h"
#endif


typedef void * (*Starter)(void *);

typedef int (*Creator)(pthread_t *, pthread_attr_t *, Starter, void *);


typedef struct Closure
{
  Starter start;
  void *argument;
} Closure;


static void *starter(Closure *closure)
{
  nextEventCountdown = getNextEventCountdown();
  const Starter start = closure->start;
  void * const argument = closure->argument;
  free(closure);
  return start(argument);
}


int pthread_create(pthread_t *thread, pthread_attr_t *attributes,
		   Starter start, void *argument)
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

#ifndef INCLUDE_sampler_unit_h
#define INCLUDE_sampler_unit_h

#include "registry.h"
#include "schemes/tuple-bits.h"


#pragma sampler_exclude_function("cbi_reporter")
static void cbi_reporter()
{
}

#pragma cilnoremove("cbi_memset0")
void cbi_memset0(void *p, unsigned int sz);
#pragma cilnoremove("cbi_guardedSetZero")
void cbi_guardedSetZero(void);

#pragma sampler_exclude_function("cbi_zeroSetter")
static void cbi_zeroSetter()
{
}

static struct cbi_Unit cbi_unit = { 0, 0, cbi_reporter, cbi_zeroSetter };

#pragma sampler_exclude_function("cbi_constructor")
static void cbi_constructor() __attribute__((constructor));
static void cbi_constructor()
{
  cbi_registerUnit(&cbi_unit);
}


#pragma sampler_exclude_function("cbi_destructor")
static void cbi_destructor() __attribute__((destructor));
static void cbi_destructor()
{
  cbi_unregisterUnit(&cbi_unit);
}


#ifdef CBI_THREADS
#include "threads/atomic-increment.h"
#pragma sampler_exclude_function("__pthread_cleanup_routine")
#endif /* CBI_THREADS */


#endif /* !INCLUDE_sampler_unit_h */

#ifndef INCLUDE_sampler_unit_h
#define INCLUDE_sampler_unit_h

#include "registry.h"


#pragma cilnoremove("samplerSiteInfo")
static const char samplerSiteInfo[] __attribute__((section(".debug_site_info")));


#pragma sampler_exclude_function("samplerReporter")
static void samplerReporter()
{
}


static struct SamplerUnit samplerUnit = { 0, 0, samplerReporter };


#pragma sampler_exclude_function("samplerConstructor")
static void samplerConstructor() __attribute__((constructor))
{
  samplerRegisterUnit(&samplerUnit);
}


#pragma sampler_exclude_function("samplerDestructor")
static void samplerDestructor() __attribute__((destructor))
{
  samplerUnregisterUnit(&samplerUnit);
}


#ifdef SAMPLER_THREADS
#pragma cilnoremove("atomicIncrementCounter")
#pragma sampler_exclude_function("atomicIncrementCounter")
static inline void atomicIncrementCounter(unsigned *counter)
{
#if __i386__
  asm ("lock incl %0"
       : "+m" (*counter)
       :
       : "cc");
#else
#error "don't know how to atomically increment on this architecture"
#endif
}
#endif /* SAMPLER_THREADS */


#endif /* !INCLUDE_sampler_unit_h */

#ifndef INCLUDE_sampler_unit_late_h
#define INCLUDE_sampler_unit_late_h

#include "registry.h"


#pragma sampler_exclude_function("samplerReporter")
static void samplerReporter()
{
}


#pragma cilnoremove("samplerCFG")
static const char samplerCFG[] __attribute__((unused, section(".debug_sampler_cfg")));

static const SamplerUnitSignature samplerUnitSignature;

static struct SamplerUnit samplerUnit = { 0, 0, samplerUnitSignature, samplerReporter };


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


#endif /* !INCLUDE_sampler_unit_late_h */

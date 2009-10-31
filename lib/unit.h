#ifndef INCLUDE_sampler_unit_h
#define INCLUDE_sampler_unit_h

#include "registry.h"
#include "schemes/tuple-bits.h"


#pragma sampler_exclude_function("cbi_reporter")
static void cbi_reporter()
{
}


static struct cbi_Unit cbi_unit = { 0, 0, cbi_reporter };


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
#pragma cilnoremove("cbi_atomicIncrementCounter")
#pragma sampler_exclude_function("cbi_atomicIncrementCounter")
static inline void cbi_atomicIncrementCounter(cbi_TupleCounter *counter)
{
#if __i386__ || __x86_64__
#  if CBI_TUPLE_COUNTER_BITS == 32 || (CBI_TUPLE_COUNTER_BITS == natural && __SIZEOF_INT__ == 4)
#    define CBI_INC_OPERAND_SUFFIX "l"
#  elif CBI_TUPLE_COUNTER_BITS == 64 || (CBI_TUPLE_COUNTER_BITS == natural && __SIZEOF_INT__ == 8)
#    define CBI_INC_OPERAND_SUFFIX "q"
#  else // neither 32- nor 64-bit counters
#    error "don't know x86 operand suffix for this tuple-counter bit size"
#  endif // neither 32- nor 64-bit counters
  asm ("lock inc" CBI_INC_OPERAND_SUFFIX " %0" : "+m" (*counter) : : "cc");
#else // neither x86 nor x86-64
#  error "don't know how to atomically increment on this architecture"
#endif
}
#endif /* CBI_THREADS */


#endif /* !INCLUDE_sampler_unit_h */

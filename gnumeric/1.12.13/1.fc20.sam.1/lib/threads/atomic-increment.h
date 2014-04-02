#ifndef INCLUDE_atomic_increment_h
#define INCLUDE_atomic_increment_h

#pragma cilnoremove("cbi_atomicIncrementCounter")
#pragma sampler_exclude_function("cbi_atomicIncrementCounter")
static inline void cbi_atomicIncrementCounter(cbi_TupleCounter *counter)
{
#if __i386__ || __x86_64__
  asm ("lock inc" CBI_TUPLE_COUNTER_X86_INC_OPERAND_SUFFIX " %0" : "+m" (*counter) : : "cc");
#else // neither x86 nor x86-64
#  error "don't know how to atomically increment on this architecture"
#endif
}

#endif /* INCLUDE_atomic_increment_h */

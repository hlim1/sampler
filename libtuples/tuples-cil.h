#ifndef INCLUDE_libtuples_tuples_cil_h
#define INCLUDE_libtuples_tuples_cil_h


/* the instrumentor will create initializers for these */
#pragma cilnoremove("counterTuples")
#pragma cilnoremove("siteInfo")
static struct CounterTuple counterTuples[];
static struct CompilationUnit compilationUnit;

static const char siteInfo[] __attribute__((section(".debug_site_info")));


static void compilationUnitConstructor() __attribute__((constructor))
{
  registerCompilationUnit(&compilationUnit);
}


static void compilationUnitDestructor() __attribute__((destructor))
{
  unregisterCompilationUnit(&compilationUnit);
}


#ifdef SAMPLER_THREADS
#pragma cilnoremove("atomicIncrementCounter")
static inline void atomicIncrementCounter(int site, int counter)
{
#if __i386__
  asm ("lock incl %0"
       : "+m" (counterTuples[site].values[counter])
       :
       : "cc");
#else
#error don't know how to atomically increment on this architecture
#endif
}
#endif /* no threads */


#endif /* !INCLUDE_libtuples_tuples_cil_h */

#ifndef INCLUDE_libscalar_pairs_scalar_pairs_cil_h
#define INCLUDE_libscalar_pairs_scalar_pairs_cil_h

#include "scalar-pairs.h"


/* the instrumentor will create initializers for these */
#pragma cilnoremove("counterTuples")
#pragma cilnoremove("siteInfo")
static CounterTuple counterTuples[];
static struct CompilationUnit compilationUnit;

static const char siteInfo[] __attribute__((section(".debug_site_info")));


#pragma cilnoremove("compilationUnitConstructor")
#pragma sampler_assume_weightless("registerCompilationUnit")
static void compilationUnitConstructor() __attribute__((constructor))
{
  registerCompilationUnit(&compilationUnit);
}


#pragma cilnoremove("compilationUnitDestructor")
#pragma sampler_assume_weightless("unregisterCompilationUnit")
static void compilationUnitDestructor() __attribute__((destructor))
{
  unregisterCompilationUnit(&compilationUnit);
}


#endif /* !INCLUDE_libscalar_pairs_scalar_pairs_cil_h */

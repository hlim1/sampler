#ifndef INCLUDE_libbranches_branches_cil_h
#define INCLUDE_libbranches_branches_cil_h

#include "branches.h"


/* the instrumentor will create initializers for these */
#pragma cilnoremove("counterTuples")
#pragma cilnoremove("siteInfo")
static CounterTuple counterTuples[];
static struct CompilationUnit compilationUnit;

static const char siteInfo[] __attribute__((section(".debug_site_info")));


#pragma sampler_assume_weightless("registerCompilationUnit")
static void compilationUnitConstructor() __attribute__((no_instrument_function, constructor))
{
  registerCompilationUnit(&compilationUnit);
}


#pragma sampler_assume_weightless("unregisterCompilationUnit")
static void compilationUnitDestructor() __attribute__((no_instrument_function, destructor))
{
  unregisterCompilationUnit(&compilationUnit);
}


#endif /* !INCLUDE_libbranches_branches_cil_h */

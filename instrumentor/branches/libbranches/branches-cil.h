#ifndef INCLUDE_libbranches_branches_cil_h
#define INCLUDE_libbranches_branches_cil_h

#include "branches.h"


/* the instrumentor will create initializers for these */
#pragma cilnoremove("counterTuples")
#pragma cilnoremove("siteInfo")
static CounterTuple counterTuples[];
static struct CompilationUnit compilationUnit;

static const char siteInfo[] __attribute__((section(".debug_site_info")));


#pragma cilnoremove("compilationUnitConstructor")
static void compilationUnitConstructor() __attribute__((constructor));
static void compilationUnitConstructor()
{
  registerCompilationUnit(&compilationUnit);
}


#pragma cilnoremove("compilationUnitDestructor")
static void compilationUnitDestructor() __attribute__((destructor));
static void compilationUnitDestructor()
{
  unregisterCompilationUnit(&compilationUnit);
}


#endif /* !INCLUDE_libbranches_branches_cil_h */

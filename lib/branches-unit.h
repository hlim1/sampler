#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "branches-types.h"
#include "registry.h"


#pragma cilnoremove("branchesCounterTuples")
static BranchTuple branchesCounterTuples[];


#pragma cilnoremove("branchesSiteInfo")
static const char branchesSiteInfo[] __attribute__((section(".debug.sampler.site_info.branches")));


#pragma cilnoremove("branchesReporter")
#pragma sampler_exclude_function("branchesReporter")
static void branchesReporter()
{
  branchesReport(sizeof(branchesCounterTuples) / sizeof(BranchTuple),
		 branchesCounterTuples);
}


#endif /* !INCLUDE_sampler_branches_unit_h */

#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "branches-types.h"
#include "unit-signature.h"


#pragma cilnoremove("branchesCounters")
static BranchTuple branchesCounters[];


#pragma cilnoremove("branchesReporter")
#pragma sampler_exclude_function("branchesReporter")
static void branchesReporter()
{
  branchesReport(samplerUnitSignature,
		 sizeof(branchesCounters) / sizeof(BranchTuple),
		 branchesCounters);
}


#endif /* !INCLUDE_sampler_branches_unit_h */

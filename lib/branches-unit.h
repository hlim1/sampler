#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "branches-types.h"
#include "unit-signature.h"


#pragma cilnoremove("branchesCounterTuples")
static BranchTuple branchesCounterTuples[];


#pragma cilnoremove("branchesReporter")
#pragma sampler_exclude_function("branchesReporter")
static void branchesReporter()
{
  branchesReport(samplerUnitSignature,
		 sizeof(branchesCounterTuples) / sizeof(BranchTuple),
		 branchesCounterTuples);
}


#endif /* !INCLUDE_sampler_branches_unit_h */

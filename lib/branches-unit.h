#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "branches.h"
#include "tuple-2.h"
#include "unit-signature.h"


#pragma cilnoremove("branchesCounters")
static struct SamplerTuple2 branchesCounters[];


#pragma cilnoremove("branchesReporter")
#pragma sampler_exclude_function("branchesReporter")
static void branchesReporter()
{
  branchesReport(samplerUnitSignature,
		 sizeof(branchesCounters) / sizeof(*branchesCounters),
		 branchesCounters);
}


#endif /* !INCLUDE_sampler_branches_unit_h */

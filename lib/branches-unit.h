#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "branches.h"
#include "tuple-2.h"
#include "unit-signature.h"


#pragma cilnoremove("branchesCounters")
static SamplerTuple2 branchesCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("branchesTimestampsFirst");
static samplerTimestamp branchesTimestampsFirst[sizeof(branchesCounters) / sizeof(*branchesCounters)];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("branchesTimestampsLast");
static samplerTimestamp branchesTimestampsLast[sizeof(branchesCounters) / sizeof(*branchesCounters)];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("branchesReporter")
#pragma sampler_exclude_function("branchesReporter")
static void branchesReporter() __attribute__((unused))
{
  branchesReport(samplerUnitSignature,
		 sizeof(branchesCounters) / sizeof(*branchesCounters),
		 branchesCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "branches", "first",
		   sizeof(branchesTimestampsFirst) / sizeof(*branchesTimestampsFirst),
		   branchesTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "branches", "last",
		   sizeof(branchesTimestampsLast) / sizeof(*branchesTimestampsLast),
		   branchesTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_branches_unit_h */

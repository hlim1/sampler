#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "scalar-pairs.h"
#include "tuple-3.h"
#include "unit-signature.h"


#pragma cilnoremove("scalarPairsCounters")
static SamplerTuple3 scalarPairsCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("scalarPairsTimestampsFirst");
static samplerTimestamp scalarPairsTimestampsFirst[sizeof(scalarPairsCounters) / sizeof(*scalarPairsCounters)];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("scalarPairsTimestampsLast");
static samplerTimestamp scalarPairsTimestampsLast[sizeof(scalarPairsCounters) / sizeof(*scalarPairsCounters)];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("scalarPairsReporter")
#pragma sampler_exclude_function("scalarPairsReporter")
static void scalarPairsReporter() __attribute__((unused))
{
  scalarPairsReport(samplerUnitSignature,
		    sizeof(scalarPairsCounters) / sizeof(*scalarPairsCounters),
		    scalarPairsCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "scalar-pairs", "first",
		   sizeof(scalarPairsTimestampsFirst) / sizeof(*scalarPairsTimestampsFirst),
		   scalarPairsTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "scalar-pairs", "last",
		   sizeof(scalarPairsTimestampsLast) / sizeof(*scalarPairsTimestampsLast),
		   scalarPairsTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */

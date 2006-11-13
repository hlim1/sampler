#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "../unit-signature.h"
#include "returns.h"
#include "tuple-3.h"


#pragma cilnoremove("returnsCounters")
static SamplerTuple3 returnsCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("returnsTimestampsFirst");
static samplerTimestamp returnsTimestampsFirst[sizeof(returnsCounters) / sizeof(*returnsCounters)];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("returnsTimestampsLast");
static samplerTimestamp returnsTimestampsLast[sizeof(returnsCounters) / sizeof(*returnsCounters)];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("returnsReporter")
#pragma sampler_exclude_function("returnsReporter")
static void returnsReporter() __attribute__((unused))
{
  returnsReport(samplerUnitSignature,
		sizeof(returnsCounters) / sizeof(*returnsCounters),
		returnsCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "returns", "first",
		   sizeof(returnsTimestampsFirst) / sizeof(*returnsTimestampsFirst),
		   returnsTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "returns", "last",
		   sizeof(returnsTimestampsLast) / sizeof(*returnsTimestampsLast),
		   returnsTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_returns_unit_h */

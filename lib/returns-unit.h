#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "returns.h"
#include "tuple-3.h"
#include "unit-signature.h"


#pragma cilnoremove("returnsCounters")
static SamplerTuple3 returnsCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("returnsTimestampsFirst");
static unsigned returnsTimestampsFirst[];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("returnsTimestampsLast");
static unsigned returnsTimestampsLast[];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("returnsReporter")
#pragma sampler_exclude_function("returnsReporter")
static void returnsReporter()
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

#ifndef INCLUDE_sampler_float_kinds_unit_h
#define INCLUDE_sampler_float_kinds_unit_h

#include "../unit-signature.h"
#include "float-kinds.h"
#include "tuple-3.h"


#pragma cilnoremove("floatKindsCounters")
static SamplerTuple9 floatKindsCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("floatKindsTimestampsFirst");
static samplerTimestamp floatKindsTimestampsFirst[sizeof(floatKindsCounters) / sizeof(*floatKindsCounters)];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("floatKindsTimestampsLast");
static samplerTimestamp floatKindsTimestampsLast[sizeof(floatKindsCounters) / sizeof(*floatKindsCounters)];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("floatKindsReporter")
#pragma sampler_exclude_function("floatKindsReporter")
static void floatKindsReporter() __attribute__((unused))
{
  floatKindsReport(samplerUnitSignature,
		    sizeof(floatKindsCounters) / sizeof(*floatKindsCounters),
		    floatKindsCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "float-kinds", "first",
		   sizeof(floatKindsTimestampsFirst) / sizeof(*floatKindsTimestampsFirst),
		   floatKindsTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "float-kinds", "last",
		   sizeof(floatKindsTimestampsLast) / sizeof(*floatKindsTimestampsLast),
		   floatKindsTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#pragma cilnoremove("floatKindsClassify")


#endif /* !INCLUDE_sampler_float_kinds_unit_h */

#ifndef INCLUDE_sampler_function_entries_unit_h
#define INCLUDE_sampler_function_entries_unit_h

#include "../unit-signature.h"
#include "function-entries.h"
#include "tuple-1.h"


#pragma cilnoremove("functionEntriesCounters")
static SamplerTuple1 functionEntriesCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("functionEntriesTimestampsFirst");
static samplerTimestamp functionEntriesTimestampsFirst[sizeof(functionEntriesCounters) / sizeof(*functionEntriesCounters)];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("functionEntriesTimestampsLast");
static samplerTimestamp functionEntriesTimestampsLast[sizeof(functionEntriesCounters) / sizeof(*functionEntriesCounters)];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("functionEntriesReporter")
#pragma sampler_exclude_function("functionEntriesReporter")
static void functionEntriesReporter() __attribute__((unused))
{
  functionEntriesReport(samplerUnitSignature,
		 sizeof(functionEntriesCounters) / sizeof(*functionEntriesCounters),
		 functionEntriesCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "function-entries", "first",
		   sizeof(functionEntriesTimestampsFirst) / sizeof(*functionEntriesTimestampsFirst),
		   functionEntriesTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "function-entries", "last",
		   sizeof(functionEntriesTimestampsLast) / sizeof(*functionEntriesTimestampsLast),
		   functionEntriesTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_function_entries_unit_h */

#ifndef INCLUDE_sampler_function_entries_unit_h
#define INCLUDE_sampler_function_entries_unit_h

#include "function-entries.h"
#include "tuple-1.h"
#include "unit-signature.h"


#pragma cilnoremove("functionEntriesCounters")
static struct SamplerTuple1 functionEntriesCounters[];


#pragma cilnoremove("functionEntriesReporter")
#pragma sampler_exclude_function("functionEntriesReporter")
static void functionEntriesReporter()
{
  functionEntriesReport(samplerUnitSignature,
		 sizeof(functionEntriesCounters) / sizeof(*functionEntriesCounters),
		 functionEntriesCounters);
}


#endif /* !INCLUDE_sampler_function_entries_unit_h */

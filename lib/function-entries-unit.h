#ifndef INCLUDE_sampler_functionEntries_unit_h
#define INCLUDE_sampler_functionEntries_unit_h

#include "function-entries-types.h"
#include "unit-signature.h"


#pragma cilnoremove("functionEntriesCounters")
static unsigned functionEntriesCounters[];


#pragma cilnoremove("functionEntriesReporter")
#pragma sampler_exclude_function("functionEntriesReporter")
static void functionEntriesReporter()
{
  functionEntriesReport(samplerUnitSignature,
		 sizeof(functionEntriesCounters) / sizeof(*functionEntriesCounters),
		 functionEntriesCounters);
}


#endif /* !INCLUDE_sampler_functionEntries_unit_h */

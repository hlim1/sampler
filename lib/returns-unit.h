#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "returns-types.h"
#include "unit-signature.h"


#pragma cilnoremove("returnsCounters")
static ReturnTuple returnsCounters[];


#pragma cilnoremove("returnsReporter")
#pragma sampler_exclude_function("returnsDestructor")
static void returnsReporter()
{
  returnsReport(samplerUnitSignature,
		sizeof(returnsCounters) / sizeof(ReturnTuple),
		returnsCounters);
}


#endif /* !INCLUDE_sampler_returns_unit_h */

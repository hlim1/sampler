#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "returns.h"
#include "tuple-3.h"
#include "unit-signature.h"


#pragma cilnoremove("returnsCounters")
static struct SamplerTuple3 returnsCounters[];


#pragma cilnoremove("returnsReporter")
#pragma sampler_exclude_function("returnsReporter")
static void returnsReporter()
{
  returnsReport(samplerUnitSignature,
		sizeof(returnsCounters) / sizeof(*returnsCounters),
		returnsCounters);
}


#endif /* !INCLUDE_sampler_returns_unit_h */

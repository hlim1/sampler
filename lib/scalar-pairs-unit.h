#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "scalar-pairs.h"
#include "tuple-3.h"
#include "unit-signature.h"


#pragma cilnoremove("scalarPairsCounters")
static struct SamplerTuple3 scalarPairsCounters[];


#pragma cilnoremove("scalarPairsReporter")
#pragma sampler_exclude_function("scalarPairsReporter")
static void scalarPairsReporter()
{
  scalarPairsReport(samplerUnitSignature,
		    sizeof(scalarPairsCounters) / sizeof(*scalarPairsCounters),
		    scalarPairsCounters);
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */

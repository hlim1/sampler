#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "scalar-pairs-types.h"
#include "unit-signature.h"


#pragma cilnoremove("scalarPairsCounters")
static ScalarPairTuple scalarPairsCounters[];


#pragma cilnoremove("scalarPairsReporter")
#pragma sampler_exclude_function("scalarPairsReporter")
static void scalarPairsReporter()
{
  scalarPairsReport(samplerUnitSignature,
		    sizeof(scalarPairsCounters) / sizeof(ScalarPairTuple),
		    scalarPairsCounters);
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */

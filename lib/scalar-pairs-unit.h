#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "scalar-pairs-types.h"
#include "unit-signature.h"


#pragma cilnoremove("scalarPairsCounterTuples")
static ScalarPairTuple scalarPairsCounterTuples[];


#pragma cilnoremove("scalarPairsReporter")
#pragma sampler_exclude_function("scalarPairsReporter")
static void scalarPairsReporter()
{
  scalarPairsReport(samplerUnitSignature,
		    sizeof(scalarPairsCounterTuples) / sizeof(ScalarPairTuple),
		    scalarPairsCounterTuples);
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */

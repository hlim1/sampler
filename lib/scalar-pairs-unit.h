#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "scalar-pairs-types.h"
#include "unit-signature.h"


#pragma cilnoremove("scalarPairsCounterTuples")
static ScalarPairTuple scalarPairsCounterTuples[];


#pragma cilnoremove("scalarPairsSiteInfo")
static const char scalarPairsSiteInfo[] __attribute__((section(".debug.sampler.site_info.scalar-pairs")));


#pragma cilnoremove("scalarPairsReporter")
#pragma sampler_exclude_function("scalarPairsReporter")
static void scalarPairsReporter()
{
  scalarPairsReport(samplerUnitSignature,
		    sizeof(scalarPairsCounterTuples) / sizeof(ScalarPairTuple),
		    scalarPairsCounterTuples);
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */

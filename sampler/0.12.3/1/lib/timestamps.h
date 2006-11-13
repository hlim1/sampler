#ifndef INCLUDE_sampler_timestamps_h
#define INCLUDE_sampler_timestamps_h

#include "signature.h"


void timestampsSetFirst(unsigned, unsigned []);
void timestampsSetLast(unsigned, unsigned []);
void timestampsSetBoth(unsigned, unsigned [], unsigned []);

void timestampsReport(const SamplerUnitSignature,
		      const char [], const char when[],
		      unsigned, const unsigned []);


#ifdef CIL
#pragma cilnoremove("timestampsSetFirst")
#pragma cilnoremove("timestampsSetLast")
#pragma cilnoremove("timestampsSetBoth")
#pragma sampler_assume_weightless("timestampsSetFirst")
#pragma sampler_assume_weightless("timestampsSetLast")
#pragma sampler_assume_weightless("timestampsSetBoth")
#endif

#endif /* !INCLUDE_sampler_timestamps_h */

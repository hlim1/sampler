#ifndef INCLUDE_sampler_timestamps_h
#define INCLUDE_sampler_timestamps_h

#include "signature.h"


typedef unsigned long long samplerTimestamp;


void timestampsSetFirst(unsigned, samplerTimestamp []);
void timestampsSetLast(unsigned, samplerTimestamp []);
void timestampsSetBoth(unsigned, samplerTimestamp [], samplerTimestamp []);

void timestampsReport(const SamplerUnitSignature,
		      const char [], const char when[],
		      unsigned, const samplerTimestamp []);


#ifdef CIL
#pragma cilnoremove("timestampsSetFirst")
#pragma cilnoremove("timestampsSetLast")
#pragma cilnoremove("timestampsSetBoth")
#pragma sampler_assume_weightless("timestampsSetFirst")
#pragma sampler_assume_weightless("timestampsSetLast")
#pragma sampler_assume_weightless("timestampsSetBoth")
#endif

#endif /* !INCLUDE_sampler_timestamps_h */

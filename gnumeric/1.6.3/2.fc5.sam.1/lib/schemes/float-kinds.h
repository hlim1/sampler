#ifndef INCLUDE_sampler_float_kinds_h
#define INCLUDE_sampler_float_kinds_h

#include "../signature.h"
#include "tuple-9.h"


void floatKindsReport(const SamplerUnitSignature, unsigned, const SamplerTuple9 []);

unsigned floatKindsClassify(long double);


#endif /* !INCLUDE_sampler_float_kinds_h */

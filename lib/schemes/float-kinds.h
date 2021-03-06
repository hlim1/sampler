#ifndef INCLUDE_sampler_float_kinds_h
#define INCLUDE_sampler_float_kinds_h

#include "../signature.h"
#include "tuple-9.h"


void cbi_floatKindsReport(const cbi_UnitSignature, unsigned, const cbi_Tuple9 []);

#ifdef CIL
#pragma sampler_assume_weightless("cbi_floatKindsClassify")
#endif /* CIL */
unsigned cbi_floatKindsClassify(long double);


#endif /* !INCLUDE_sampler_float_kinds_h */

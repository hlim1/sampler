#ifndef INCLUDE_sampler_g_object_unref_h
#define INCLUDE_sampler_g_object_unref_h

#include "../signature.h"
#include "tuple-4.h"


void cbi_gObjectUnrefReport(const cbi_UnitSignature, unsigned, const cbi_Tuple4 []);

unsigned cbi_gObjectUnrefClassify(void *);

#ifdef CIL
#pragma sampler_assume_weightless("cbi_gObjectUnrefClassify")
#pragma sampler_assume_weightless("g_object_unref")
#endif /* CIL */


#endif /* !INCLUDE_sampler_g_object_unref_h */

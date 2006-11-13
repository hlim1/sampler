#ifndef INCLUDE_sampler_g_object_unref_h
#define INCLUDE_sampler_g_object_unref_h

#include "../signature.h"
#include "tuple-4.h"


void gObjectUnrefReport(const SamplerUnitSignature, unsigned, const SamplerTuple4 []);

unsigned gObjectUnrefClassify(void *);


#endif /* !INCLUDE_sampler_g_object_unref_h */

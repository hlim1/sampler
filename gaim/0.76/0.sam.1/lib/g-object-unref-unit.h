#ifndef INCLUDE_sampler_g_object_unref_unit_h
#define INCLUDE_sampler_g_object_unref_unit_h

#include "g-object-unref-types.h"
#include "unit-signature.h"


#pragma cilnoremove("gObjectUnrefCounters")
static GObjectUnrefTuple gObjectUnrefCounters[];


#pragma cilnoremove("gObjectUnrefReporter")
#pragma sampler_exclude_function("gObjectUnrefReporter")
static void gObjectUnrefReporter()
{
  gObjectUnrefReport(samplerUnitSignature,
		    sizeof(gObjectUnrefCounters) / sizeof(GObjectUnrefTuple),
		    gObjectUnrefCounters);
}


#pragma cilnoremove("gObjectUnrefClassify")


#endif /* !INCLUDE_sampler_g_object_unref_unit_h */

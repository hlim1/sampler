#ifndef INCLUDE_sampler_g_object_unref_unit_h
#define INCLUDE_sampler_g_object_unref_unit_h

#include "g-object-unref.h"
#include "tuple-4.h"
#include "unit-signature.h"


#pragma cilnoremove("gObjectUnrefCounters")
static SamplerTuple4 gObjectUnrefCounters[];

#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("gObjectUnrefTimestampsFirst");
static unsigned gObjectUnrefTimestampsFirst[];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("gObjectUnrefTimestampsLast");
static unsigned gObjectUnrefTimestampsLast[];
#endif /* SAMPLER_TIMESTAMP_LAST */


#pragma cilnoremove("gObjectUnrefReporter")
#pragma sampler_exclude_function("gObjectUnrefReporter")
static void gObjectUnrefReporter() __attribute__((unused))
{
  gObjectUnrefReport(samplerUnitSignature,
		    sizeof(gObjectUnrefCounters) / sizeof(*gObjectUnrefCounters),
		    gObjectUnrefCounters);
#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "g-object-unref", "first",
		   sizeof(gObjectUnrefTimestampsFirst) / sizeof(*gObjectUnrefTimestampsFirst),
		   gObjectUnrefTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "g-object-unref", "last",
		   sizeof(gObjectUnrefTimestampsLast) / sizeof(*gObjectUnrefTimestampsLast),
		   gObjectUnrefTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#pragma cilnoremove("gObjectUnrefClassify")


#endif /* !INCLUDE_sampler_g_object_unref_unit_h */

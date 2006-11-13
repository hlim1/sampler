#ifndef INCLUDE_sampler_bounds_unit_h
#define INCLUDE_sampler_bounds_unit_h

#include "bounds.h"
#include "unit-signature.h"


#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("boundsTimestampsFirst");
static unsigned boundsTimestampsFirst[];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("boundsTimestampsLast");
static unsigned boundsTimestampsLast[];
#endif /* SAMPLER_TIMESTAMP_LAST */


static void boundsReportDump();


#pragma cilnoremove("boundsReporter")
#pragma sampler_exclude_function("boundsReporter")
static void boundsReporter() __attribute__((unused))
{
  boundsReportBegin(samplerUnitSignature);
  boundsReportDump();
  boundsReportEnd();

#ifdef SAMPLER_TIMESTAMP_FIRST
  timestampsReport(samplerUnitSignature, "bounds", "first",
		   sizeof(boundsTimestampsFirst) / sizeof(*boundsTimestampsFirst),
		   boundsTimestampsFirst);
#endif /* SAMPLER_TIMESTAMP_FIRST */
#ifdef SAMPLER_TIMESTAMP_LAST
  timestampsReport(samplerUnitSignature, "bounds", "last",
		   sizeof(boundsTimestampsLast) / sizeof(*boundsTimestampsLast),
		   boundsTimestampsLast);
#endif /* SAMPLER_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_bounds_unit_h */

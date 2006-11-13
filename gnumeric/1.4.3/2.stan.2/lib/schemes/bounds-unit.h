#ifndef INCLUDE_sampler_bounds_unit_h
#define INCLUDE_sampler_bounds_unit_h

#include "../unit-signature.h"
#include "bounds.h"


#ifdef SAMPLER_TIMESTAMP_FIRST
#pragma cilnoremove("boundsTimestampsFirst");
static samplerTimestamp boundsTimestampsFirst[];
#endif /* SAMPLER_TIMESTAMP_FIRST */

#ifdef SAMPLER_TIMESTAMP_LAST
#pragma cilnoremove("boundsTimestampsLast");
static samplerTimestamp boundsTimestampsLast[];
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

#ifndef INCLUDE_sampler_coverage_unit_h
#define INCLUDE_sampler_coverage_unit_h

#include "../unit-signature.h"
#include "coverage.h"
#include "tuple-1.h"


#pragma cilnoremove("cbi_coverageCounters")
static cbi_Tuple1 cbi_coverageCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_coverageTimestampsFirst");
static cbi_Timestamp cbi_coverageTimestampsFirst[sizeof(cbi_coverageCounters) / sizeof(*cbi_coverageCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_coverageTimestampsLast");
static cbi_Timestamp cbi_coverageTimestampsLast[sizeof(cbi_coverageCounters) / sizeof(*cbi_coverageCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_coverageReporter")
#pragma sampler_exclude_function("cbi_coverageReporter")
static void cbi_coverageReporter() __attribute__((unused));
static void cbi_coverageReporter()
{
  cbi_coverageReport(cbi_unitSignature,
		     sizeof(cbi_coverageCounters) / sizeof(*cbi_coverageCounters),
		     cbi_coverageCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "coverage", "first",
		       sizeof(cbi_coverageTimestampsFirst) / sizeof(*cbi_coverageTimestampsFirst),
		       cbi_coverageTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "coverage", "last",
		       sizeof(cbi_coverageTimestampsLast) / sizeof(*cbi_coverageTimestampsLast),
		       cbi_coverageTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_coverage_unit_h */

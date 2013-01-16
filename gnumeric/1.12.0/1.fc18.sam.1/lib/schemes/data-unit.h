#ifndef INCLUDE_sampler_data_unit_h
#define INCLUDE_sampler_data_unit_h

#include "../unit-signature.h"
#include "data.h"
#include "tuple-2.h"


#pragma cilnoremove("cbi_dataCounters")
static cbi_Tuple2 cbi_dataCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_dataTimestampsFirst");
static cbi_Timestamp cbi_dataTimestampsFirst[sizeof(cbi_dataCounters) / sizeof(*cbi_dataCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_dataTimestampsLast");
static cbi_Timestamp cbi_dataTimestampsLast[sizeof(cbi_dataCounters) / sizeof(*cbi_dataCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_dataReporter")
#pragma sampler_exclude_function("cbi_dataReporter")
static void cbi_dataReporter() __attribute__((unused));
static void cbi_dataReporter()
{
  cbi_dataReport(cbi_unitSignature,
		     sizeof(cbi_dataCounters) / sizeof(*cbi_dataCounters),
		     cbi_dataCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "data", "first",
		       sizeof(cbi_dataTimestampsFirst) / sizeof(*cbi_dataTimestampsFirst),
		       cbi_dataTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "data", "last",
		       sizeof(cbi_dataTimestampsLast) / sizeof(*cbi_dataTimestampsLast),
		       cbi_dataTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_data_unit_h */

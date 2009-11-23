#ifndef INCLUDE_sampler_yields_unit_h
#define INCLUDE_sampler_yields_unit_h

#include "../unit-signature.h"
#include "yields.h"
#include "tuple-2.h"

#pragma cilnoremove("cbi_yieldsCounters")
static cbi_Tuple2 cbi_yieldsCounters[0];


#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_yieldsTimestampsFirst");
static cbi_Timestamp cbi_yieldsTimestampsFirst[sizeof(cbi_yieldsCounters) / sizeof(*cbi_yieldsCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_yieldsTimestampsLast");
static cbi_Timestamp cbi_yieldsTimestampsLast[sizeof(cbi_yieldsCounters) / sizeof(*cbi_yieldsCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_yield")
#pragma sampler_exclude_function("cbi_yield")


#pragma sampler_assume_weightless("cbi_yield")

#pragma cilnoremove("cbi_yieldsReporter")
#pragma sampler_exclude_function("cbi_yieldsReporter")
static void cbi_yieldsReporter() __attribute__((unused));
static void cbi_yieldsReporter()
{
  cbi_yieldsReport(cbi_unitSignature,
		     sizeof(cbi_yieldsCounters) / sizeof(*cbi_yieldsCounters),
		     cbi_yieldsCounters);

#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "yields", "first",
		       sizeof(cbi_yieldsTimestampsFirst) / sizeof(*cbi_yieldsTimestampsFirst),
		       cbi_yieldsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "yields", "last",
		       sizeof(cbi_yieldsTimestampsLast) / sizeof(*cbi_yieldsTimestampsLast),
		       cbi_yieldsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */

}



#endif /* !INCLUDE_sampler_yields_unit_h */

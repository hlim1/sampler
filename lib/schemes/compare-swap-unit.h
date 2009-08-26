#ifndef INCLUDE_sampler_fun_reentries_unit_h
#define INCLUDE_sampler_fun_reentries_unit_h

#include "../unit-signature.h"
#include "fun-reentries.h"
#include "tuple-2.h"


#pragma cilnoremove("cbi_funReentriesCounters")
static cbi_Tuple2 cbi_funReentriesCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_funReentriesTimestampsFirst");
static cbi_Timestamp cbi_funReentriesTimestampsFirst[sizeof(cbi_funReentriesCounters) / sizeof(*cbi_funReentriesCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_funReentriesTimestampsLast");
static cbi_Timestamp cbi_funReentriesTimestampsLast[sizeof(cbi_funReentriesCounters) / sizeof(*cbi_funReentriesCounters)];
#endif /* CBI_TIMESTAMP_LAST */

#pragma cilnoremove("cbi_funre_lock")
#pragma sampler_exclude_function("cbi_funre_lock")
#pragma sampler_assume_weightless("cbi_funre_lock")


#pragma cilnoremove("cbi_funre_unlock")
#pragma sampler_exclude_function("cbi_funre_unlock")
#pragma sampler_assume_weightless("cbi_funre_unlock")

#pragma cilnoremove("cbi_funReentriesReporter")
#pragma sampler_exclude_function("cbi_funReentriesReporter")
static void cbi_funReentriesReporter() __attribute__((unused));
static void cbi_funReentriesReporter()
{
  cbi_funReentriesReport(cbi_unitSignature,
			    sizeof(cbi_funReentriesCounters) / sizeof(*cbi_funReentriesCounters),
			    cbi_funReentriesCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "fun-reentries", "first",
		       sizeof(cbi_funReentriesTimestampsFirst) / sizeof(*cbi_funReentriesTimestampsFirst),
		       cbi_funReentriesTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "fun-reentries", "last",
		       sizeof(cbi_funReentriesTimestampsLast) / sizeof(*cbi_funReentriesTimestampsLast),
		       cbi_funReentriesTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_fun_reentries_unit_h */

#ifndef INCLUDE_sampler_compareSwap_unit_h
#define INCLUDE_sampler_compareSwap_unit_h

#include "../unit-signature.h"
#include "compare-swap.h"
#include "tuple-2.h"


#pragma cilnoremove("cbi_compareSwapSampling")
#pragma cilnoremove("cbi_compareSwapInitiator")

#pragma cilnoremove("cbi_compareSwapCounters")
static cbi_Tuple2 cbi_compareSwapCounters[0];


#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_compareSwapTimestampsFirst");
static cbi_Timestamp cbi_compareSwapTimestampsFirst[sizeof(cbi_compareSwapCounters) / sizeof(*cbi_compareSwapCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_compareSwapTimestampsLast");
static cbi_Timestamp cbi_compareSwapTimestampsLast[sizeof(cbi_compareSwapCounters) / sizeof(*cbi_compareSwapCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_compareSwap_yield")
#pragma sampler_exclude_function("cbi_compareSwap_yield")
#pragma sampler_assume_weightless("cbi_compareSwap_yield")
static inline void cbi_compareSwap_yield()
{
  sched_yield();
}



#pragma cilnoremove("cbi_compareSwap_sampling_on")
#pragma sampler_exclude_function("cbi_compareSwap_sampling_on")
#pragma sampler_assume_weightless("cbi_compareSwap_sampling_on")
static inline void cbi_compareSwap_sampling_on()
{
  cbi_compareSwapSampling = 1;
  cbi_compareSwapCounter = 0;
}


#pragma cilnoremove("cbi_compareSwap_sampling_off")
#pragma sampler_exclude_function("cbi_compareSwap_sampling_off")
#pragma sampler_assume_weightless("cbi_compareSwap_sampling_off")
static inline void cbi_compareSwap_sampling_off()
{
  if (cbi_compareSwapCounter > 99)
    {
      cbi_compareSwapSampling = 0;
      cbi_compareSwapCounter = 0;
      cbi_dict_clear();
    }
  else
    cbi_compareSwapCounter++;
}


#pragma cilnoremove("cbi_dict_lookup")
#pragma sampler_exclude_function("cbi_dict_lookup")
#pragma sampler_assume_weightless("cbi_dict_lookup")


#pragma cilnoremove("cbi_dict_set")
#pragma sampler_exclude_function("cbi_dict_set")
#pragma sampler_assume_weightless("cbi_dict_set")



#pragma cilnoremove("cbi_dict_clear")
#pragma sampler_exclude_function("cbi_dict_clear")
#pragma sampler_assume_weightless("cbi_dict_clear")

#pragma cilnoremove("cbi_dict_insert")
#pragma sampler_exclude_function("cbi_dict_insert")
#pragma sampler_assume_weightless("cbi_dict_insert")

#pragma cilnoremove("cbi_dict_test_and_insert")
#pragma sampler_exclude_function("cbi_dict_test_and_insert")
#pragma sampler_assume_weightless("cbi_dict_test_and_insert")



#pragma cilnoremove("cbi_compareSwapReporter")
#pragma sampler_exclude_function("cbi_compareSwapReporter")
static void cbi_compareSwapReporter() __attribute__((unused));
static void cbi_compareSwapReporter()
{
  cbi_compareSwapReport(cbi_unitSignature,
		     sizeof(cbi_compareSwapCounters) / sizeof(*cbi_compareSwapCounters),
		     cbi_compareSwapCounters);

#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "compare-swap", "first",
		       sizeof(cbi_compareSwapTimestampsFirst) / sizeof(*cbi_compareSwapTimestampsFirst),
		       cbi_compareSwapTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "compare-swap", "last",
		       sizeof(cbi_compareSwapTimestampsLast) / sizeof(*cbi_compareSwapTimestampsLast),
		       cbi_compareSwapTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */

}



#endif /* !INCLUDE_sampler_compareSwap_unit_h */

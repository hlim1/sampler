#ifndef INCLUDE_sampler_atoms_unit_h
#define INCLUDE_sampler_atoms_unit_h

#include "../unit-signature.h"
#include "atoms.h"
#include "tuple-2.h"

#pragma cilnoremove("cci_crap")
#pragma cilnoremove("cbi_atomsCounters")
static cbi_Tuple2 cbi_atomsCounters[0];


#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_atomsTimestampsFirst");
static cbi_Timestamp cbi_atomsTimestampsFirst[sizeof(cbi_atomsCounters) / sizeof(*cbi_atomsCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_atomsTimestampsLast");
static cbi_Timestamp cbi_atomsTimestampsLast[sizeof(cbi_atomsCounters) / sizeof(*cbi_atomsCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_atoms_yield")
#pragma sampler_exclude_function("cbi__atoms_yield")
#pragma sampler_assume_weightless("cbi_atoms_yield")


#pragma cilnoremove("cbi_thread_self")
#pragma sampler_exclude_function("cbi_thread_self")
#pragma sampler_assume_weightless("cbi_thread_self")


#pragma cilnoremove("cbi_atoms_lock")
#pragma sampler_exclude_function("cbi_atoms_lock")
#pragma sampler_assume_weightless("cbi_atoms_lock")


#pragma cilnoremove("cbi_atoms_unlock")
#pragma sampler_exclude_function("cbi_atoms_unlock")
#pragma sampler_assume_weightless("cbi_atoms_unlock")


#pragma cilnoremove("cbi_dict_lookup")
#pragma sampler_exclude_function("cbi_dict_lookup")
#pragma sampler_assume_weightless("cbi_dict_lookup")


#pragma cilnoremove("cbi_dict_set")
#pragma sampler_exclude_function("cbi_dict_set")
#pragma sampler_assume_weightless("cbi_dict_set")



#pragma cilnoremove("cbi_dict_clear")
#pragma sampler_exclude_function("cbi_dict_clear")
#pragma sampler_assume_weightless("cbi_dict_clear")

#pragma cilnoremove("cbi_dict_test_and_insert")
#pragma sampler_exclude_function("cbi_dict_test_and_insert")
#pragma sampler_assume_weightless("cbi_dict_test_and_insert")



#pragma cilnoremove("cbi_atomsReporter")
#pragma sampler_exclude_function("cbi_atomsReporter")
static void cbi_atomsReporter() __attribute__((unused));
static void cbi_atomsReporter()
{
  cbi_atomsReport(cbi_unitSignature,
		     sizeof(cbi_atomsCounters) / sizeof(*cbi_atomsCounters),
		     cbi_atomsCounters);

#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "atoms", "first",
		       sizeof(cbi_atomsTimestampsFirst) / sizeof(*cbi_atomsTimestampsFirst),
		       cbi_atomsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "atoms", "last",
		       sizeof(cbi_atomsTimestampsLast) / sizeof(*cbi_atomsTimestampsLast),
		       cbi_atomsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */

}



#endif /* !INCLUDE_sampler_atoms_unit_h */

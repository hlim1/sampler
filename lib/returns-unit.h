#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "returns-types.h"
#include "registry.h"


#pragma cilnoremove("returnsCounterTuples")
static ReturnTuple returnsCounterTuples[];


#pragma cilnoremove("returnsSiteInfo")
static const char returnsSiteInfo[] __attribute__((section(".debug.sampler.site_info.returns")));


#pragma cilnoremove("returnsReporter")
#pragma sampler_exclude_function("returnsDestructor")
static void returnsReporter()
{
  returnsReport(sizeof(returnsCounterTuples) / sizeof(ReturnTuple),
		returnsCounterTuples);
}


#endif /* !INCLUDE_sampler_returns_unit_h */

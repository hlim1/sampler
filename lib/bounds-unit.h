#ifndef INCLUDE_sampler_bounds_unit_h
#define INCLUDE_sampler_bounds_unit_h

#include "bounds.h"
#include "unit-signature.h"


static void boundsReportDump();


#pragma cilnoremove("boundsReporter")
#pragma sampler_exclude_function("boundsReporter")
static void boundsReporter()
{
  boundsReportBegin(samplerUnitSignature);
  boundsReportDump();
  boundsReportEnd();
}


#endif /* !INCLUDE_sampler_bounds_unit_h */

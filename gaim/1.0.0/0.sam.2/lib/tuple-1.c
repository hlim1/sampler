#include <stdio.h>
#include "report.h"
#include "tuple-1.h"


void samplesDump1(unsigned count, const SamplerTuple1 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\n", tuples[scan]);
}

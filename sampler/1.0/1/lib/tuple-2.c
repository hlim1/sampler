#include <stdio.h>
#include "report.h"
#include "tuple-2.h"


void samplesDump2(unsigned count, const SamplerTuple2 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1]);
}

#include <stdio.h>
#include "report.h"
#include "tuple-4.h"


void samplesDump4(unsigned count, const SamplerTuple4 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\t%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2],
	    tuples[scan][3]);
}

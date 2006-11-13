#include <stdio.h>
#include "../report.h"
#include "tuple-3.h"


void samplesDump3(unsigned count, const SamplerTuple3 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);
}

#include "report.h"
#include "scalar-pairs-types.h"


void scalarPairsReport(unsigned count, const ScalarPairTuple tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "\n%u\t%u\t%u",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);
}

#include "report.h"
#include "returns-types.h"


void returnsReport(unsigned count, const ReturnTuple tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "\n%u\t%u\t%u",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);
}

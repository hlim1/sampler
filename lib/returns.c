#include "report.h"
#include "returns-types.h"


void returnsReport(unsigned count, const ReturnTuple tuples[])
{
  unsigned scan;

  fputs("<scheme id=\"returns\">", reportFile);

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "\n%u\t%u\t%u",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);

  fputs("\n</scheme>\n", reportFile);
}

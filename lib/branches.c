#include "branches-types.h"
#include "report.h"


void branchesReport(unsigned count, const BranchTuple tuples[])
{
  unsigned scan;

  fputs("<scheme id=\"branches\">", reportFile);

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "\n%u\t%u",
	    tuples[scan][0],
	    tuples[scan][1]);

  fputs("\n</scheme>\n", reportFile);
}

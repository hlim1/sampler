#include <libreport/report.h>
#include <libreport/unit.h>
#include "branches.h"


void reportCompilationUnit(const struct CompilationUnit *unit)
{
  unsigned scan;

  for (scan = 0; scan < sizeof(unit->signature); ++scan)
    fprintf(reportFile, "%02x", unit->signature[scan]);

  for (scan = 0; scan < unit->count; ++scan)
    fprintf(reportFile, "\n%u\t%u",
	    unit->tuples[scan].values[0],
	    unit->tuples[scan].values[1]);

  fputs("\n\n", reportFile);
}

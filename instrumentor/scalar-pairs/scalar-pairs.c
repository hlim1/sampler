#include <lib/report.h>
#include <lib/unit.h>
#include "scalar-pairs.h"


void reportCompilationUnit(const struct CompilationUnit *unit)
{
  unsigned scan;

  for (scan = 0; scan < sizeof(unit->signature); ++scan)
    fprintf(reportFile, "%02x", unit->signature[scan]);

  for (scan = 0; scan < unit->count; ++scan)
    fprintf(reportFile, "\n%u\t%u\t%u",
	    unit->tuples[scan][0],
	    unit->tuples[scan][1],
	    unit->tuples[scan][2]);

  fputs("\n\n", reportFile);
}

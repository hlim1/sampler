#include <libreport/report.h>
#include "scalar-pairs.h"


static struct CompilationUnit anchor = { &anchor, &anchor, "", 0, 0 };


void registerCompilationUnit(struct CompilationUnit *unit)
{
  unit->prev = &anchor;
  unit->next = anchor.next;
  anchor.next->prev = unit;
  anchor.next = unit;
}


void unregisterCompilationUnit(struct CompilationUnit *unit)
{
  if (unit->prev) unit->prev->next = unit->next;
  if (unit->next) unit->next->prev = unit->prev;
}


void dumpSamples(FILE * const logFile)
{
  const struct CompilationUnit *unit;
  for (unit = anchor.next; unit != &anchor; unit = unit->next)
    {
      unsigned scan;

      for (scan = 0; scan < sizeof(unit->signature); ++scan)
	fprintf(logFile, "%02x", unit->signature[scan]);

      for (scan = 0; scan < unit->count; ++scan)
	fprintf(logFile, "\n%u\t%u\t%u",
		unit->tuples[scan][0],
		unit->tuples[scan][1],
		unit->tuples[scan][2]);

      fputs("\n\n", logFile);
    }
}

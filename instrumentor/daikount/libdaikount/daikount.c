#include <libreport/report.h>
#include "daikount.h"


struct Invariant anchor = { &anchor, &anchor, { 0, 0, 0 }, 0, 0, 0, 0, 0, 0 };


void dumpSamples(FILE * const logFile)
{
  const struct Invariant *invariant;

  for (invariant = anchor.next; invariant != &anchor; invariant = invariant->next)
    fprintf(logFile, "%s\t%u\t%s\t%s\t%s\t%u\t%u\t%u\t%u\n",
	    invariant->file, invariant->line, invariant->function,
	    invariant->left, invariant->right, invariant->id,
	    invariant->counters[0], invariant->counters[1],
	    invariant->counters[2]);
}

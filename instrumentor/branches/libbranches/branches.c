#include <libreport/report.h>
#include "branches.h"


struct BranchProfile anchor = { &anchor, &anchor, { 0, 0 }, 0, 0, 0, 0, 0 };


#define obstack_chunk_alloc malloc
#define obstack_chunk_free free


void dumpSamples(FILE * const logFile)
{
  const struct BranchProfile *profile;

  for (profile = anchor.next; profile != &anchor; profile = profile->next)
    fprintf(logFile, "%s\t%u\t%s\t%u\t%s\t%u\t%u\n",
	    profile->file, profile->line, profile->function,
	    profile->id, profile->condition,
	    profile->counters[0], profile->counters[1]);
}

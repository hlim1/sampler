#include <libreport/report.h>
#include "branches.h"


static struct BranchProfile anchor = { &anchor, &anchor, "", 0 };


void registerBranchProfile(struct BranchProfile *profile)
{
  profile->prev = &anchor;
  profile->next = anchor.next;
  anchor.next->prev = profile;
  anchor.next = profile;
}


void unregisterBranchProfile(struct BranchProfile *profile)
{
  if (profile->prev) profile->prev->next = profile->next;
  if (profile->next) profile->next->prev = profile->prev;
}


void dumpSamples(FILE * const logFile)
{
  const struct BranchProfile *profile;
  for (profile = anchor.next; profile != &anchor; profile = profile->next)
    {
      unsigned scan;
      const BranchCounters * const sites = profile->sites;
      const unsigned sitesCount = profile->count;

      for (scan = 0; scan < sizeof(profile->signature); ++scan)
	fprintf(logFile, "%02x", profile->signature[scan]);

      for (scan = 0; scan < sitesCount; ++scan)
	fprintf(logFile, "\n%u\t%u", sites[scan][0], sites[scan][1]);

      fputs("\n\n", logFile);
    }
}

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "countdown.h"
#include "cyclic.h"


unsigned nextEventCountdown = UINT_MAX;

const unsigned *precomputedCountdowns = 0;
unsigned nextCountdownSlot = 0;


#define MAP_SIZE (PRECOMPUTE_COUNT * sizeof(*precomputedCountdowns))


__attribute__((constructor)) static void initialize()
{
  const char * const environ = getenv("SAMPLER_COUNTDOWNS");
  if (!environ)
    {
      fputs("countdown/cyclic: must name precomputed countdowns file in $SAMPLER_COUNTDOWNS\n", stderr);
      exit(2);
    }
  else
    {
      const int fd = open(environ, O_RDONLY);
      if (fd == -1)
	{
	  fprintf(stderr, "countdown/cyclic: cannot open \"%s\": %s\n", environ, strerror(errno));
	  exit(2);
	}
      else
	{
	  void * const mapping = mmap(0, MAP_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
	  if (mapping == (void *) -1)
	    {
	      fprintf(stderr, "countdown/cyclic: cannot mmap \"%s\": %s\n", environ, strerror(errno));
	      exit(2);
	    }

	  close(fd);
	  precomputedCountdowns = (const unsigned *) mapping;
	  nextEventCountdown = getNextCountdown();
	}
    }
}


__attribute__((destructor)) static void shutdown()
{
  if (precomputedCountdowns != 0)
    {
      munmap((void *) precomputedCountdowns, MAP_SIZE);
      precomputedCountdowns = 0;
    }
}

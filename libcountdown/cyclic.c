#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "cyclic.h"
#include "cyclic-size.h"


#define MAP_SIZE (PRECOMPUTE_COUNT * sizeof(unsigned))


const unsigned *loadCountdowns(const char envar[])
{
  const char * const environ = getenv(envar);
  if (!environ)
    {
      fprintf(stderr, __FUNCTION__ ": must name precomputed countdowns file in $%s\n", envar);
      exit(2);
    }
  else
    {
      const int fd = open(environ, O_RDONLY);
      if (fd == -1)
	{
	  fprintf(stderr, __FUNCTION__ ": cannot open \"%s\": %s\n", environ, strerror(errno));
	  exit(2);
	}
      else
	{
	  void * const mapping = mmap(0, MAP_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
	  if (mapping == (void *) -1)
	    {
	      fprintf(stderr, __FUNCTION__ ": cannot mmap \"%s\": %s\n", environ, strerror(errno));
	      exit(2);
	    }

	  close(fd);
	  return (const unsigned *) mapping;
	}
    }
}


void unloadCountdowns(const unsigned *mapping)
{
  if (mapping != 0)
    munmap((void *) mapping, MAP_SIZE);
}

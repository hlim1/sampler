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
#include "cyclic-size.h"


#define MAP_SIZE (PRECOMPUTE_COUNT * sizeof(unsigned))


const void * const providesLibCyclic;

const unsigned *nextEventPrecomputed = 0;
unsigned nextEventSlot = 0;


static void failed(const char function[])
{
  fprintf(stderr, "%s failed: %s\n", function, strerror(errno));
  exit(2);
}


static void *checkedMmap(int prot, int fd)
{
  void * const mapping = mmap(0, MAP_SIZE, prot, MAP_PRIVATE, fd, 0);

  if (mapping == (void *) -1)
    failed("mmap");

  if (close(fd))
    failed("close");

  return mapping;
}


static int checkedOpen(const char filename[])
{
  const int fd = open(filename, O_RDONLY);

  if (fd == -1)
    fprintf(stderr, "open of %s failed: %s\n", filename, strerror(errno));

  return fd;
}


__attribute__((constructor)) static void initialize()
{
  const char envar[] = "SAMPLER_EVENT_COUNTDOWNS";
  const char * const environ = getenv(envar);
  void *mapping;
  
  if (environ)
    {
      const int fd = checkedOpen(environ);
      mapping = checkedMmap(PROT_READ, fd);
    }
  else
    {
      int fd;
      fprintf(stderr, "%s: no countdowns file named in $%s; using extreme sparsity\n",  __FUNCTION__, envar);
      fd = checkedOpen("/dev/zero");
      mapping = checkedMmap(PROT_READ | PROT_WRITE, fd);
      memset(mapping, -1, MAP_SIZE);
      mapping = mremap(mapping, MAP_SIZE, MAP_SIZE, PROT_READ);
      if (mapping == (void *) -1)
	failed("mremap");
    }

  nextEventPrecomputed = (const unsigned *) mapping;
  nextEventCountdown = getNextEventCountdown();
}


__attribute__((destructor)) static void finalize()
{
  if (nextEventPrecomputed != 0)
    munmap((void *) nextEventPrecomputed, MAP_SIZE);
}

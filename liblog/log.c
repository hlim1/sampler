#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "log.h"


unsigned nextLogCountdown = 0;


#define likely(p)   __builtin_expect(p, 1)
#define unlikely(p) __builtin_expect(p, 0)


static void resetCountdown()
{
  while (likely(random() % 4096 != 0))
    {
      ++nextLogCountdown;
      if (unlikely(nextLogCountdown == 0))
      {
	nextLogCountdown = UINT_MAX;
	break;
      }
}


__attribute__((constructor, unused)) static void initialize()
{
  resetCountdown();
}


void logWrite(const char filename[], unsigned line,
	      const void *address, unsigned size,
	      const void *data __attribute__((unused)))
{
  if (likely(nextLogCountdown != 0))
    --nextLogCountdown;
  else
    {
      resetCountdown();
      
      fprintf(stderr, "%s:%u: write %p for %u bytes\n",
	      filename, line, address, size);
    }
}

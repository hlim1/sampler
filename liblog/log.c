#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "log.h"


unsigned nextLogCountdown = 0;


static void resetCountdown()
{
  unsigned countUp = 0;
  
  while (random() % 4096 != 0)
    {
      ++countUp;
      if (countUp == 0)
      {
	countUp = UINT_MAX;
	break;
      }
    }

  nextLogCountdown = countUp;
}


__attribute__((constructor, unused)) static void initialize()
{
  resetCountdown();
}


void skipWrite()
{
  assert(nextLogCountdown > 0);
  --nextLogCountdown;
}


void logWrite(const char filename[], unsigned line,
	      const void *address, unsigned size,
	      const void *data __attribute__((unused)))
{
  if (nextLogCountdown > 0)
    skipWrite();
  else
    {
      resetCountdown();
      
      fprintf(stderr, "%s:%u: write %p for %u bytes\n",
	      filename, line, address, size);
    }
}

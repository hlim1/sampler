#include <limits.h>
#include <stdio.h>
#include "log.h"


unsigned nextLogCountdown = 0;


static void resetCountdown()
{
  nextLogCountdown = 0;
}


void logWrite(const char filename[], unsigned line,
	      const void *address, unsigned size,
	      const void *data __attribute__((unused)))
{
  if (nextLogCountdown)
    --nextLogCountdown;
  else
    {
      resetCountdown();
      
      fprintf(stderr, "%s:%u: write %p for %u bytes\n",
	      filename, line, address, size);
    }
}

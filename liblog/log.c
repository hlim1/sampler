#include <stdio.h>
#include "log.h"


void logWrite(const char filename[], unsigned line,
	      void *address, unsigned size,
	      void *data __attribute__((unused)))
{
  fprintf(stderr, "%s:%u: write %p for %u bytes\n",
	  filename, line, address, size);
}

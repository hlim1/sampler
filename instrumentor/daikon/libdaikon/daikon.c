#include <stdio.h>
#include <stdlib.h>
#include "daikon.h"


static FILE *logFile;
static unsigned initCount;


__attribute__((constructor)) static void initialize()
{
  if (!initCount++)
    {
      const char * const filename = getenv("SAMPLER_FILE");
  
      if (filename)
	{
	  logFile = fopen(filename, "w");
	  if (!logFile) perror("logger: fopen error");
	}
      else
	fputs("logger: not recording samples; no $SAMPLER_FILE given in environment\n", stderr);
    }
}


__attribute__((destructor)) static void storeShutdown()
{
  if (!--initCount && logFile)
    {
      const int error = fclose(logFile);
      if (error) perror("logger: fclose error");
      logFile = 0;
    }
}


void checkInvariant(const char location[], const char function[], const char expr[], intmax_t value)
{
  if (logFile)
    {
      fprintf(logFile, "%s\t%s\t%s\t%jd\n", location, function, expr, value);
      fflush(logFile);
    }
}

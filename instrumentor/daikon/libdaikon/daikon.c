#include <stdio.h>
#include <stdlib.h>
#include "daikon.h"


static FILE *logFile;


__attribute__((constructor)) static void initialize()
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


__attribute__((destructor)) static void storeShutdown()
{
  if (logFile)
    {
      const int error = fclose(logFile);
      if (error) perror("logger: fclose error");
      logFile = 0;
    }
}


void checkInvariant(const char location[], const char expr[], intmax_t value)
{
  if (logFile)
    {
      fprintf(logFile, "%s\t%s\t%jd\n", location, expr, value);
      fflush(logFile);
    }
}

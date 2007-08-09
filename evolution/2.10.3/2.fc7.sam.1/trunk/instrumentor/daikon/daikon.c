#include <stdio.h>
#include <stdlib.h>
#include <config.h>
#include "daikon.h"


FILE *daikonLogFile;
unsigned daikonInitCount;


__attribute__((constructor)) static void initialize()
{
  if (!daikonInitCount++)
    {
      const char * const filename = getenv("SAMPLER_FILE");
  
      if (filename)
	{
	  daikonLogFile = fopen(filename, "w");
	  if (!daikonLogFile) perror("logger: fopen error");
	}
      else
	fputs("logger: not recording samples; no $SAMPLER_FILE given in environment\n", stderr);
    }
}


__attribute__((destructor)) static void storeShutdown()
{
  if (!--daikonInitCount && daikonLogFile)
    {
      const int error = fclose(daikonLogFile);
      if (error) perror("logger: fclose error");
      daikonLogFile = 0;
    }
}


void checkInvariant(const char location[], const char function[], const char expr[], intmax_t value)
{
  if (daikonLogFile)
    {
#ifdef HAVE_FORMAT_STRING_TYPE_MODIFIER_j
      fprintf(daikonLogFile, "%s\t%s\t%s\t%jd\n", location, function, expr, value);
#else
      fprintf(daikonLogFile, "%s\t%s\t%s\t%Ld\n", location, function, expr, (long long) value);
#endif
      fflush(daikonLogFile);
    }
}

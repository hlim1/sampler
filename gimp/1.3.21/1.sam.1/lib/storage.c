#include <stdio.h>
#include <stdlib.h>
#include "../libcountdown/event.h"
#include "log.h"
#include "storage.h"


const char logSignature[] = {
  '\212',
  's', 'a', 'm',
  '\r', '\n',
  '\032',
  '\n'
};

unsigned logInitCount;


__attribute__((constructor)) static void initialize()
{
  if (!logInitCount++)
    {
      const char * const filename = getenv("SAMPLER_FILE");
  
      if (filename)
	{
	  storeInitialize(filename);
	  unsetenv("SAMPLER_FILE");
	  logTableau(logSignature, sizeof(logSignature));
	  logTableau(&nextEventCountdown, sizeof nextEventCountdown);
	}
      else
	fputs("logger: not recording samples; no $SAMPLER_FILE given in environment\n", stderr);
    }
}


__attribute__((destructor)) static void finalize()
{
  if (!--logInitCount)
    {
      const char terminator = -1;
      logTableau(&terminator, sizeof(terminator));
      logTableau(logSignature, sizeof(logSignature));
      storeShutdown();
    }
}

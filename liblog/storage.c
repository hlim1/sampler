#include <stdio.h>
#include <stdlib.h>
#include "../libcountdown/countdown.h"
#include "log.h"
#include "storage.h"


static const char signature[] = {
  '\212',
  's', 'a', 'm',
  '\r', '\n',
  '\032',
  '\n'
};


__attribute__((constructor)) static void initialize()
{
  const char * const filename = getenv("SAMPLER_FILE");
  
  if (filename)
    {
      storeInitialize(filename);
      logTableau(signature, sizeof(signature));
      logTableau(&nextEventCountdown, sizeof nextEventCountdown);
    }
  else
    fprintf(stderr, "logger: not recording samples; no $SAMPLER_FILE given in environment\n");
}


__attribute__((destructor)) static void shutdown()
{
  const char terminator = -1;
  logTableau(&terminator, sizeof(terminator));
  logTableau(signature, sizeof(signature));
  storeShutdown();
}

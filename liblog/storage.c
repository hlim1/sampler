#include <stdio.h>
#include <stdlib.h>
#include "log.h"
#include "storage.h"


__attribute__((constructor)) static void initialize()
{
  const char * const filename = getenv("SAMPLER_FILE");
  
  if (filename)
    storeInitialize(filename);
  else
    fprintf(stderr, "logger: not recording samples; no $SAMPLER_FILE given in environment\n");
}


__attribute__((destructor)) static void shutdown()
{
  const char terminator = -1;
  logTableau(&terminator, sizeof(terminator));
}

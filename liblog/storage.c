#include <stdio.h>
#include <stdlib.h>
#include "storage.h"


const char *storageFilename()
{
  const char * const filename = getenv("SAMPLER_FILE");
  
  if (!filename)
    fprintf(stderr, "logger: not recording samples; no $SAMPLER_FILE given in environment\n");

  return filename;
}

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "log.h"
#include "primitive.h"
#include "storage.h"


void logSiteBegin(const char *file, unsigned line)
{
  static const char *priorFile = 0;

  if (priorFile == file)
    storeNull();
  else
    {
      priorFile = file;
      storeString(file);
    }

  storeData(&line, sizeof(line));
}

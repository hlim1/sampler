#include <stdio.h>
#include "log.h"
#include "storage.h"

FILE *logFile;


void storeInitialize(const char *filename)
{
  logFile = fopen(filename, "w");
  if (!logFile) perror("logger: fopen error");
}


void storeShutdown()
{
  if (logFile)
    {
      const int error = fclose(logFile);
      if (error) perror("logger: fclose error");
      logFile = 0;
    }
}


/**********************************************************************/


void logTableau(const void *tableau, size_t desired)
{
  if (logFile)
    {
      const size_t actual = fwrite(tableau, desired, 1, logFile);
      if (actual != 1)
	perror("logger: fwrite error");
    }
}

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include "log.h"
#include "storage.h"


int logFd = -1;


void storeInitialize(const char *filename)
{
  logFd = open(filename, O_WRONLY | O_CREAT | O_TRUNC,
	       S_IRUSR | S_IRGRP | S_IROTH |
	       S_IWUSR | S_IWGRP | S_IWOTH);
      
  if (logFd == -1) perror("logger: open error");
}


void storeShutdown()
{
  if (logFd != -1)
    {
      const int error = close(logFd);
      if (error) perror("logger: close error");
      logFd = -1;
    }
}


/**********************************************************************/


void logTableau(const void *tableau, size_t desired)
{
  if (logFd != -1)
    {
      const ssize_t actual = write(logFd, tableau, desired);
      if (actual != (ssize_t) desired)
	perror("logger: write error");
    }
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <unistd.h>
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


void storeData(const void *value, size_t desired)
{
  if (logFd != -1)
    {
      const ssize_t actual = write(logFd, value, desired);
      if (actual != (ssize_t) desired)
	perror("logger: write error");
    }
}


void storeByte(char byte)
{
  storeData(&byte, sizeof(byte));
}


void storeString(const char *text)
{
  storeData(text, strlen(text) + 1);
}


void storeValue(const char *name,
		enum PrimitiveType primitive,
		const void *value, size_t size)
{
  if (logFd != -1)
    {
      const char typeCode = (char) primitive;
      const size_t length = strlen(name) + 1;
  
      struct iovec vector[] = {
	{ (void *) name, length },
	{ (void *) &typeCode, sizeof(typeCode) },
	{ (void *) value, size }
      };

      const ssize_t actual = writev(logFd, vector, sizeof(vector) / sizeof(*vector));
      if (actual <= 0 || (size_t) actual != length + sizeof(typeCode) + size)
	perror("logger: writev error");
    }
}

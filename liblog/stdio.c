#include <stdio.h>
#include "storage.h"

FILE *logFile;


__attribute__((constructor)) static void initialize()
{
  const char * const filename = storageFilename();
  
  if (filename)
    {
      logFile = fopen(filename, "w");
      if (!logFile) perror("logger: fopen error");
    }
}


__attribute__((destructor)) static void shutdown()
{
  if (logFile)
    {
      const int error = fclose(logFile);
      if (error) perror("logger: fclose error");
      logFile = 0;
    }
}


/**********************************************************************/


void storeData(const void *value, size_t desired)
{
  if (logFile)
    {
      const ssize_t actual = fwrite_unlocked(value, desired, 1, logFile);
      if (actual != 1)
	perror("logger: fwrite error");
    }
}


static void storeByte(char byte)
{
  if (logFile)
    {
      const int error = fputc_unlocked(byte, logFile);
      if (error == -1)
	perror("logger: fputc error");
    }
}


void storeNull()
{
  storeByte(0);
}


void storeString(const char *text)
{
  if (logFile)
    {
      const int error = fputs_unlocked(text, logFile);
      if (error == -1)
	perror("logger: fputs error");
      storeNull();
    }
}


void storeValue(const char *name,
		enum PrimitiveType primitive,
		const void *value, size_t size)
{
  const char typeCode = (char) primitive;
  storeString(name);
  storeByte(typeCode);
  storeData(value, size);
}

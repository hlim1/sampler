#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "log.h"
#include "primitive.h"


static void logData(const void *value, size_t desired)
{
  const ssize_t actual = write(2, value, desired);
  if (actual != (ssize_t) desired)
    perror("logger");
}


static void logNull()
{
  char byte = '\0';
  logData(&byte, sizeof(byte));
}


static void logString(const char *text)
{
  logData(text, strlen(text) + 1);
}


static void logValue(const char *name,
		     enum PrimitiveType primitive,
		     const void *value, size_t size)
{
  const char typeCode = (char) primitive;
  logString(name);
  logData(&typeCode, sizeof(typeCode));
  logData(value, size);
}


/**********************************************************************/


void logSiteBegin(const char *file, unsigned line)
{
  static const char *priorFile = 0;

  if (priorFile == file)
    logNull();
  else
    {
      priorFile = file;
      logString(file);
    }

  logData(&line, sizeof(line));
}  


void logSiteEnd()
{
  logNull();
}


/**********************************************************************/


void logChar(const char *name, char value)
{
  logValue(name, Char, &value, sizeof(value));
}


void logSignedChar(const char *name, signed char value)
{
  logValue(name, SignedChar, &value, sizeof(value));
}


void logUnsignedChar(const char *name, unsigned char value)
{
  logValue(name, UnsignedChar, &value, sizeof(value));
}


void logInt(const char *name, int value)
{
  logValue(name, Int, &value, sizeof(value));
}


void logUnsignedInt(const char *name, unsigned value)
{
  logValue(name, UnsignedInt, &value, sizeof(value));
}


void logShort(const char *name, short value)
{
  logValue(name, Short, &value, sizeof(value));
}


void logUnsignedShort(const char *name, unsigned short value)
{
  logValue(name, UnsignedShort, &value, sizeof(value));
}


void logLong(const char *name, long value)
{
  logValue(name, Long, &value, sizeof(value));
}


void logUnsignedLong(const char *name, unsigned long value)
{
  logValue(name, UnsignedLong, &value, sizeof(value));
}


void logLongLong(const char *name, long long value)
{
  logValue(name, LongLong, &value, sizeof(value));
}


void logUnsignedLongLong(const char *name, unsigned long long value)
{
  logValue(name, UnsignedLongLong, &value, sizeof(value));
}


void logFloat(const char *name, float value)
{
  logValue(name, Float, &value, sizeof(value));
}


void logDouble(const char *name, double value)
{
  logValue(name, Double, &value, sizeof(value));
}


void logLongDouble(const char *name, long double value)
{
  logValue(name, LongDouble, &value, sizeof(value));
}


void logPointer(const char *name, const void * value)
{
  logValue(name, Pointer, &value, sizeof(value));
}

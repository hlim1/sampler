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


void logSiteEnd()
{
  storeNull();
}


/**********************************************************************/


void logChar(const char *name, char value)
{
  storeValue(name, Char, &value, sizeof(value));
}


void logSignedChar(const char *name, signed char value)
{
  storeValue(name, SignedChar, &value, sizeof(value));
}


void logUnsignedChar(const char *name, unsigned char value)
{
  storeValue(name, UnsignedChar, &value, sizeof(value));
}


void logInt(const char *name, int value)
{
  storeValue(name, Int, &value, sizeof(value));
}


void logUnsignedInt(const char *name, unsigned value)
{
  storeValue(name, UnsignedInt, &value, sizeof(value));
}


void logShort(const char *name, short value)
{
  storeValue(name, Short, &value, sizeof(value));
}


void logUnsignedShort(const char *name, unsigned short value)
{
  storeValue(name, UnsignedShort, &value, sizeof(value));
}


void logLong(const char *name, long value)
{
  storeValue(name, Long, &value, sizeof(value));
}


void logUnsignedLong(const char *name, unsigned long value)
{
  storeValue(name, UnsignedLong, &value, sizeof(value));
}


void logLongLong(const char *name, long long value)
{
  storeValue(name, LongLong, &value, sizeof(value));
}


void logUnsignedLongLong(const char *name, unsigned long long value)
{
  storeValue(name, UnsignedLongLong, &value, sizeof(value));
}


void logFloat(const char *name, float value)
{
  storeValue(name, Float, &value, sizeof(value));
}


void logDouble(const char *name, double value)
{
  storeValue(name, Double, &value, sizeof(value));
}


void logLongDouble(const char *name, long double value)
{
  storeValue(name, LongDouble, &value, sizeof(value));
}


void logPointer(const char *name, const void * value)
{
  storeValue(name, Pointer, &value, sizeof(value));
}

#include <stdio.h>
#include "decoder.h"


void siteCountdown(unsigned countdown)
{
  printf("... %u ...\n", countdown);
}


void siteFile(const char *file)
{
  printf("%s:", file);
}


void siteLine(unsigned line)
{
  printf("%u\n", line);
}


void siteEnd()
{
}


////////////////////////////////////////////////////////////////////////


void sampleExpr(const char *expression)
{
  printf("\t%s == ", expression);
}


////////////////////////////////////////////////////////////////////////


void sampleChar(char value)
{
  printf("%hhu\n", value);
}


void sampleSignedChar(signed char value)
{
  printf("%hhd\n", value);
}


void sampleUnsignedChar(unsigned char value)
{
  printf("%hhu\n", value);
}


void sampleInt(int value)
{
  printf("%d\n", value);
}


void sampleUnsignedInt(unsigned int value)
{
  printf("%u\n", value);
}


void sampleShort(short value)
{
  printf("%hd\n", value);
}


void sampleUnsignedShort(unsigned short value)
{
  printf("%u\n", value);
}


void sampleLong(long value)
{
  printf("%ld\n", value);
}


void sampleUnsignedLong(unsigned long value)
{
  printf("%lu\n", value);
}


void sampleLongLong(long long value)
{
  printf("%Ld\n", value);
}


void sampleUnsignedLongLong(unsigned long long value)
{
  printf("%Lu\n", value);
}


void sampleFloat(float value)
{
  printf("%g\n", value);
}


void sampleDouble(double value)
{
  printf("%g\n", value);
}


void sampleLongDouble(long double value)
{
  printf("%Lg\n", value);
}


void samplePointer(const void * value)
{
  printf("%p\n", value);
}

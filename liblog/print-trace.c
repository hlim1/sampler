#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include "decoder.h"


unsigned long long sampleCounter;


int main()
{
  switch (yylex())
    {
    case Normal:
      puts("\n(terminated normally)");
      return 0;
    case Abnormal:
      puts("\n(terminated abnormally)");
      return 0;
    default:
      puts("\n(garbled trace)");
      return 1;
    }
}


void siteCountdown(unsigned countdown)
{
  assert(ULONG_LONG_MAX - sampleCounter >= countdown);
  sampleCounter += countdown;
  printf("#%Lu...\n", sampleCounter);
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
  printf("(char) %hhu\n", value);
}


void sampleSignedChar(signed char value)
{
  printf("(signed char) %hhd\n", value);
}


void sampleUnsignedChar(unsigned char value)
{
  printf("(unsigned char) %hhu\n", value);
}


void sampleInt(int value)
{
  printf("(int) %d\n", value);
}


void sampleUnsignedInt(unsigned int value)
{
  printf("(unsigned int) %u\n", value);
}


void sampleShort(short value)
{
  printf("(short) %hd\n", value);
}


void sampleUnsignedShort(unsigned short value)
{
  printf("(unsigned short) %u\n", value);
}


void sampleLong(long value)
{
  printf("(long) %ld\n", value);
}


void sampleUnsignedLong(unsigned long value)
{
  printf("(unsigned long) %lu\n", value);
}


void sampleLongLong(long long value)
{
  printf("(long long) %Ld\n", value);
}


void sampleUnsignedLongLong(unsigned long long value)
{
  printf("(unsigned long long) %Lu\n", value);
}


void sampleFloat(float value)
{
  printf("(float) %g\n", value);
}


void sampleDouble(double value)
{
  printf("(double) %g\n", value);
}


void sampleLongDouble(long double value)
{
  printf("(long double) %Lg\n", value);
}


void samplePointer(const void * value)
{
  printf("(const void *) %p\n", value);
}

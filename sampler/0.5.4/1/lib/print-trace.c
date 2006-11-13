#define _GNU_SOURCE
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


void sampleInt8(int8_t value)
{
  printf("(int8_t) %hhd\n", value);
}


void sampleUInt8(uint8_t value)
{
  printf("(uint8_t) %hhu\n", value);
}


void sampleInt16(int16_t value)
{
  printf("(int16_t) %hd\n", value);
}


void sampleUInt16(uint16_t value)
{
  printf("(uint16_t) %hu\n", value);
}


void sampleInt32(int32_t value)
{
  printf("(int32_t) %d\n", value);
}


void sampleUInt32(uint32_t value)
{
  printf("(uint32_t) %u\n", value);
}


void sampleInt64(int64_t value)
{
  printf("(int64_t) %Ld\n", value);
}


void sampleUInt64(uint64_t value)
{
  printf("(uint64_t) %Lu\n", value);
}


void sampleFloat32(float value)
{
  printf("(float32_t) %g\n", value);
}


void sampleFloat64(double value)
{
  printf("(float64_t) %g\n", value);
}


void sampleFloat96(long double value)
{
  printf("(float96_t) %Lg\n", value);
}


void samplePointer32(const void *value)
{
  printf("(pointer) %p\n", (const void *) value);
}

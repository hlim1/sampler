#define _GNU_SOURCE
#include <liblog/decoder.h>
#include <sstream>
#include "Session.h"
#include "quote.h"
#include "require.h"


static unsigned long long sampleCounter = 0;
static string file;
static string expression;


void siteCountdown(unsigned countdown)
{
  require(ULONG_LONG_MAX - sampleCounter >= countdown, "samples counter has wrapped around");
  sampleCounter += countdown;
}


void siteFile(const char *file)
{
  ::file = quote(file);
}


void siteLine(unsigned line)
{
  Session::singleton.push_back(Site(sampleCounter, file, line));
}


void siteEnd()
{
}


////////////////////////////////////////////////////////////////////////


void sampleExpr(const char *expression)
{
  ::expression = quote(expression);
}


////////////////////////////////////////////////////////////////////////


template<typename T> void sampleValue(T value)
{
  const Sample<T> sample(expression, value);
  Session::singleton.back().addSample(sample);
}


void sampleInt8(int8_t value)
{
  sampleValue(value);
}


void sampleUInt8(uint8_t value)
{
  sampleValue(value);
}


void sampleInt16(int16_t value)
{
  sampleValue(value);
}


void sampleUInt16(uint16_t value)
{
  sampleValue(value);
}


void sampleInt32(int32_t value)
{
  sampleValue(value);
}


void sampleUInt32(uint32_t value)
{
  sampleValue(value);
}


void sampleInt64(int64_t value)
{
  sampleValue(value);
}


void sampleUInt64(uint64_t value)
{
  sampleValue(value);
}


void sampleFloat32(float value)
{
  sampleValue(value);
}


void sampleFloat64(double value)
{
  sampleValue(value);
}


void sampleFloat96(long double value)
{
  sampleValue(value);
}


void samplePointer32(const void *value)
{
  sampleValue(value);
}

#define _GNU_SOURCE
#include <liblog/decoder.h>
#include <sstream>
#include "Session.h"
#include "quote.h"
#include "require.h"


static unsigned long long sampleCounter = 0;
static string file;
static string expression;

Session session;


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
  session.push_back(Site(sampleCounter, file, line));
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


template<class T> void sampleValue(PrimitiveType typeCode, T value)
{
  ostringstream stringify;
  stringify << value;
  session.back().push_back(Sample(expression, typeCode, stringify.str()));
}


void sampleChar(char value)
{
  sampleValue(Char, (unsigned) value);
}


void sampleSignedChar(signed char value)
{
  sampleValue(SignedChar, (int) value);
}


void sampleUnsignedChar(unsigned char value)
{
  sampleValue(UnsignedChar, (unsigned) value);
}


void sampleInt(int value)
{
  sampleValue(Int, value);
}


void sampleUnsignedInt(unsigned int value)
{
  sampleValue(UnsignedInt, value);
}


void sampleShort(short value)
{
  sampleValue(Short, value);
}


void sampleUnsignedShort(unsigned short value)
{
  sampleValue(UnsignedShort, value);
}


void sampleLong(long value)
{
  sampleValue(Long, value);
}


void sampleUnsignedLong(unsigned long value)
{
  sampleValue(UnsignedLong, value);
}


void sampleLongLong(long long value)
{
  sampleValue(LongLong, value);
}


void sampleUnsignedLongLong(unsigned long long value)
{
  sampleValue(UnsignedLongLong, value);
}


void sampleFloat(float value)
{
  sampleValue(Float, value);
}


void sampleDouble(double value)
{
  sampleValue(Double, value);
}


void sampleLongDouble(long double value)
{
  sampleValue(LongDouble, value);
}


void samplePointer(const void *value)
{
  sampleValue(Pointer, value);
}

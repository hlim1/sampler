#define _GNU_SOURCE
#include <cassert>
#include <climits>
#include <clocale>
#include <iomanip>
#include <liblog/decoder.h>
#include <liblog/primitive.h>
#include <sstream>
#include "database.h"
#include "require.h"
#include "session.h"


static unsigned long long sampleCounter = 0;
static string file;
static string expression;


static string quote(const char *suspicious)
{
  ostringstream result;
  result << oct << setfill('0') << '\'';
  
  for (const char *scan = suspicious; *scan; ++scan)
    if (isprint(*scan) && *scan != '\'')
      result << *scan;
    else
      result << '\\' << setw(3) << (int) *scan;

  result << '\'';
  return result.str();
}


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
  ostringstream command;
  command << "INSERT INTO sites (session, sample, file, line) VALUES ("
	  << sessionId << ", " << sampleCounter << ", " << file << ", " << line
	  << ')';
  require(database.ExecCommandOk(command.str().c_str()));
}


////////////////////////////////////////////////////////////////////////


void sampleExpr(const char *expression)
{
  ::expression = quote(expression);
}


////////////////////////////////////////////////////////////////////////


template<class T> void sampleValue(PrimitiveType typeCode, T value)
{
  ostringstream command;
  command << "INSERT INTO samples (session, sample, expression, type, value) VALUES ("
	  << sessionId << ", " << sampleCounter << ", "
	  << expression << ", " << typeCode << ", '" << value << "')";
  require(database.ExecCommandOk(command.str().c_str()));
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

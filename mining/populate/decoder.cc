#include <clocale>
#include <liblog/decoder.h>
#include <liblog/primitive.h>
#include <sstream>
#include "database.h"


static const char *file;
static unsigned line;


void siteFile(const char *file)
{
  ::file = file;
}


void siteLine(unsigned line)
{
  ::line = line;
  const ExecStatusType status = database.Exec("COPY import_site FROM STDIN");
  require(status == PGRES_COPY_IN);
}


void siteEnd()
{
  database.PutLine("\\.\n");
  const int error = database.EndCopy();
  require(!error);

  require(database.ExecCommandOk("TRUNCATE import_site"));
  
}


////////////////////////////////////////////////////////////////////////


void sampleExpr(const char *value)
{
  for (const char *scan = value; *scan; ++scan)
    if (!isprint(*scan))
      cerr << "warning: suspicious character '" << *scan << "' in sampled expression" << endl;

  database.PutLine(value);
}


////////////////////////////////////////////////////////////////////////


template<class T> void sampleValue(PrimitiveType typeCode, T value)
{
  ostringstream formatter;
  formatter << '\t' << typeCode
	    << '\t' << value
	    << '\n';
  database.PutLine(formatter.str().c_str());
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

#include <stdio.h>
#include "../report.h"
#include "bounds.h"
#include "samples.h"


void boundsReportBegin(const SamplerUnitSignature signature)
{
  samplesBegin(signature, "bounds");
}


void boundsReportEnd()
{
  samplesEnd();
}


/**********************************************************************/


void boundDumpSignedChar(signed char min, signed char max)
{
  fprintf(reportFile, "%hhd\t%hhd\n", min, max);
}


void boundDumpUnsignedChar(unsigned char min, unsigned char max)
{
  fprintf(reportFile, "%hhu\t%hhu\n", min, max);
}


void boundDumpSignedShort(signed short min, signed short max)
{
  fprintf(reportFile, "%hd\t%hd\n", min, max);
}


void boundDumpUnsignedShort(unsigned short min, unsigned short max)
{
  fprintf(reportFile, "%hu\t%hu\n", min, max);
}


void boundDumpSignedInt(signed int min, signed int max)
{
  fprintf(reportFile, "%d\t%d\n", min, max);
}


void boundDumpUnsignedInt(unsigned int min, unsigned int max)
{
  fprintf(reportFile, "%u\t%u\n", min, max);
}


void boundDumpSignedLong(signed long min, signed long max)
{
  fprintf(reportFile, "%ld\t%ld\n", min, max);
}


void boundDumpUnsignedLong(unsigned long min, unsigned long max)
{
  fprintf(reportFile, "%lu\t%lu\n", min, max);
}


void boundDumpSignedLongLong(signed long long min, signed long long max)
{
  fprintf(reportFile, "%Ld\t%Ld\n", min, max);
}


void boundDumpUnsignedLongLong(unsigned long long min, unsigned long long max)
{
  fprintf(reportFile, "%Lu\t%Lu\n", min, max);
}


void boundDumpPointer(const void * min, const void * max)
{
  fprintf(reportFile, "%p\t%p\n", min, max);
}

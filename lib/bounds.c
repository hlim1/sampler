#include <stdio.h>
#include "bounds-types.h"
#include "report.h"


void boundsReportBegin(const unsigned char *signature)
{
  samplesBegin(signature, "bounds");
}


void boundsReportEnd()
{
  samplesEnd();
}


/**********************************************************************/


void boundDumpChar(char min, char max)
{
  printf("%c\t%c\n", min, max);
}


void boundDumpSignedShort(signed short min, signed short max)
{
  printf("%hd\t%hd\n", min, max);
}


void boundDumpUnsignedShort(unsigned short min, unsigned short max)
{
  printf("%hu\t%hu\n", min, max);
}


void boundDumpSignedInt(signed int min, signed int max)
{
  printf("%d\t%d\n", min, max);
}


void boundDumpUnsignedInt(unsigned int min, unsigned int max)
{
  printf("%u\t%u\n", min, max);
}


void boundDumpSignedLong(signed long min, signed long max)
{
  printf("%ld\t%ld\n", min, max);
}


void boundDumpUnsignedLong(unsigned long min, unsigned long max)
{
  printf("%lu\t%lu\n", min, max);
}


void boundDumpSignedLongLong(signed long long min, signed long long max)
{
  printf("%Ld\t%Ld\n", min, max);
}


void boundDumpUnsignedLongLong(unsigned long long min, unsigned long long max)
{
  printf("%Lu\t%Lu\n", min, max);
}


void boundDumpPointer(const void * min, const void * max)
{
  printf("%p\t%p\n", min, max);
}

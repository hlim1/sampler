#include <stdio.h>
#include "../report.h"
#include "samples.h"


void samplesBegin(const SamplerUnitSignature signature, const char scheme[])
{
  fprintf(reportFile,
	  "<samples unit=\""
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "\" scheme=\"%s\">\n",
	  signature[ 0], signature[ 1], signature[ 2], signature[ 3],
	  signature[ 4], signature[ 5], signature[ 6], signature[ 7],
	  signature[ 8], signature[ 9], signature[10], signature[11],
	  signature[12], signature[13], signature[14], signature[15],
	  scheme);
}


void samplesEnd()
{
  fputs("</samples>\n", reportFile);
}

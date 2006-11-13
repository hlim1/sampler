#include <stdio.h>
#include "../report.h"
#include "../timestamps.h"


void timestampsReport(const SamplerUnitSignature signature,
		      const char scheme[], const char when[],
		      unsigned count, const samplerTimestamp times[])
{
  unsigned scan;

  fprintf(reportFile,
	  "<timestamps unit=\""
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "\" scheme=\"%s\" when=\"%s\">\n",
	  signature[ 0], signature[ 1], signature[ 2], signature[ 3],
	  signature[ 4], signature[ 5], signature[ 6], signature[ 7],
	  signature[ 8], signature[ 9], signature[10], signature[11],
	  signature[12], signature[13], signature[14], signature[15],
	  scheme, when);

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%Lu\n", times[scan]);

  fputs("</timestamps>\n", reportFile);
}

#include <stdio.h>
#include "../report.h"
#include "tuple-1.h"


void cbi_samplesDump1(unsigned count, const cbi_Tuple1 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(cbi_reportFile, "%" CBI_TUPLE_COUNTER_FORMAT "\n", tuples[scan]);
}

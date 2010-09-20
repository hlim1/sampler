#include <stdio.h>
#include "../report.h"
#include "tuple-2.h"


void cbi_samplesDump2(unsigned count, const cbi_Tuple2 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(cbi_reportFile,
	    "%" CBI_TUPLE_COUNTER_FORMAT "\t"
	    "%" CBI_TUPLE_COUNTER_FORMAT "\n",
	    tuples[scan][0],
	    tuples[scan][1]);
}

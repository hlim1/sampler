#include <stdio.h>
#include "report.h"
#include "tuple-1.h"
#include "tuple-2.h"
#include "tuple-3.h"
#include "tuple-4.h"


#ifdef SAMPLER_TIMESTAMPS
#  define DUMP(format, ...) do { fprintf(reportFile, "%u\t" format, tuples[scan].timestamp, __VA_ARGS__); } while (0)
#else  /* no timestamps */
#  define DUMP(format, ...) do { fprintf(reportFile, format, __VA_ARGS__); } while (0)
#endif /* no timestamps */


void samplesDump1(unsigned count, const struct SamplerTuple1 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    DUMP("%u\n", tuples[scan].count);
}


void samplesDump2(unsigned count, const struct SamplerTuple2 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    DUMP("%u\t%u\n",
	 tuples[scan].count[0],
	 tuples[scan].count[1]);
}


void samplesDump3(unsigned count, const struct SamplerTuple3 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    DUMP("%u\t%u\t%u\n",
	 tuples[scan].count[0],
	 tuples[scan].count[1],
	 tuples[scan].count[2]);
}


void samplesDump4(unsigned count, const struct SamplerTuple4 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    DUMP("%u\t%u\t%u\t%u\n",
	 tuples[scan].count[0],
	 tuples[scan].count[1],
	 tuples[scan].count[2],
	 tuples[scan].count[3]);
}

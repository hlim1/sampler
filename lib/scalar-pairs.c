#include "report.h"
#include "scalar-pairs.h"


void scalarPairsReport(const unsigned char *signature,
		       unsigned count, const struct SamplerTuple3 tuples[])
{
  samplesBegin(signature, "scalar-pairs");
  samplesDump3(count, tuples);
  samplesEnd();
}

#include "report.h"
#include "samples.h"
#include "scalar-pairs.h"


void scalarPairsReport(const SamplerUnitSignature signature,
		       unsigned count, const SamplerTuple3 tuples[])
{
  samplesBegin(signature, "scalar-pairs");
  samplesDump3(count, tuples);
  samplesEnd();
}

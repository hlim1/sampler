#include "returns.h"
#include "samples.h"


void returnsReport(const SamplerUnitSignature signature,
		   unsigned count, const SamplerTuple3 tuples[])
{
  samplesBegin(signature, "returns");
  samplesDump3(count, tuples);
  samplesEnd();
}

#include "branches.h"
#include "samples.h"


void branchesReport(const SamplerUnitSignature signature,
		    unsigned count, const SamplerTuple2 sites[])
{
  samplesBegin(signature, "branches");
  samplesDump2(count, sites);
  samplesEnd();
}

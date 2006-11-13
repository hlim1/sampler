#include "function-entries.h"
#include "samples.h"
#include "tuple-2.h"


void functionEntriesReport(const SamplerUnitSignature signature,
			   unsigned count, const SamplerTuple1 counts[])
{
  samplesBegin(signature, "function-entries");
  samplesDump1(count, counts);
  samplesEnd();
}

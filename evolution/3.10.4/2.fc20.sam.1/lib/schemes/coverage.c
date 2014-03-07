#include "coverage.h"
#include "samples.h"


void cbi_coverageReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple1 sites[])
{
  cbi_samplesBegin(signature, "coverage");
  cbi_samplesDump1(count, sites);
  cbi_samplesEnd();
}

#include "data.h"
#include "samples.h"


void cbi_dataReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple1 counts[])
{
  cbi_samplesBegin(signature, "data");
  cbi_samplesDump1(count, counts);
  cbi_samplesEnd();
}

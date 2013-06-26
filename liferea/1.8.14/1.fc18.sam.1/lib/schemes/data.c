#include "data.h"
#include "samples.h"


void cbi_dataReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "data");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();
}

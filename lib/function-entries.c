#include "function-entries.h"
#include "report.h"


void functionEntriesReport(const unsigned char *signature,
			   unsigned count, const struct SamplerTuple1 counts[])
{
  samplesBegin(signature, "function-entries");
  samplesDump1(count, counts);
  samplesEnd();
}

#include "report.h"
#include "returns.h"


void returnsReport(const unsigned char *signature,
		   unsigned count, const struct SamplerTuple3 tuples[])
{
  samplesBegin(signature, "returns");
  samplesDump3(count, tuples);
  samplesEnd();
}

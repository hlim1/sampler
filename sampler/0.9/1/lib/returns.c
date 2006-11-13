#include "report.h"
#include "returns-types.h"


void returnsReport(const unsigned char *signature,
		   unsigned count, const ReturnTuple tuples[])
{
  samplesBegin(signature, "returns");
  samplesDump3(count, tuples);
  samplesEnd();
}

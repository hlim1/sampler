#include "report.h"
#include "scalar-pairs-types.h"


void scalarPairsReport(const unsigned char *signature,
		       unsigned count, const ScalarPairTuple tuples[])
{
  samplesBegin(signature, "scalar-pairs");
  samplesDump3(count, tuples);
  samplesEnd();
}

#include "report.h"
#include "g-object-unref-types.h"


void gObjectUnrefReport(const unsigned char *signature,
			unsigned count, const GObjectUnrefTuple tuples[])
{
  samplesBegin(signature, "g-object-unref");
  samplesDump4(count, tuples);
  samplesEnd();
}

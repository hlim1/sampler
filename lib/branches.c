#include "branches.h"
#include "report.h"


void branchesReport(const unsigned char *signature,
		    unsigned count, const struct SamplerTuple2 sites[])
{
  samplesBegin(signature, "branches");
  samplesDump2(count, sites);
  samplesEnd();
}

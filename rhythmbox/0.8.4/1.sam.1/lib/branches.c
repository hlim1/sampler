#include "branches-types.h"
#include "report.h"


void branchesReport(const unsigned char *signature,
		    unsigned count, const BranchTuple tuples[])
{
  samplesBegin(signature, "branches");
  samplesDump2(count, tuples);
  samplesEnd();
}

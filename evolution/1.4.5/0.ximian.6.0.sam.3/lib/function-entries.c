#include "function-entries-types.h"
#include "report.h"


void functionEntriesReport(const unsigned char *signature,
			   unsigned count, const unsigned counts[])
{
  samplesBegin(signature, "function-entries");
  samplesDump1(count, counts);
  samplesEnd();
}

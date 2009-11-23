#include "yields.h"
#include "samples.h"

/*modelled after function-entries*/
void cbi_yieldsReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "yields");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();

}
//cleanup: 
int cbi_yield(int id)
{
  //int x;
  //printf("yielding at %d\n",id);
  sched_yield();
  //printf("yield res %d\n", x);
  id =1;
  return id;
}

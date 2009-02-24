#include "atoms.h"
#include "samples.h"

/*modelled after function-entries*/

void cbi_atomsReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 counts[])
{
  cbi_samplesBegin(signature, "atoms");
  cbi_samplesDump2(count, counts);
  cbi_samplesEnd();

}
//cleanup: 
int cbi_thread_self()
{
  int temp = pthread_self();
  return temp;
}

void cbi_atoms_yield()
{
  sched_yield();
}

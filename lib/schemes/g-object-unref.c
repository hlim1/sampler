#include <glib-object.h>
#include "g-object-unref.h"
#include "samples.h"
#include "tuple-4.h"


void gObjectUnrefReport(const SamplerUnitSignature signature,
			unsigned count, const SamplerTuple4 tuples[])
{
  samplesBegin(signature, "g-object-unref");
  samplesDump4(count, tuples);
  samplesEnd();
}

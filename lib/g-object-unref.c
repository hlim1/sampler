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


unsigned gObjectUnrefClassify(gpointer chaff)
{
  if (G_LIKELY(G_IS_OBJECT(chaff)))
    switch (((GObject *) chaff)->ref_count)
      {
      case 0:
	return 0;
      case 1:
	return 1;
      default:
	return 2;
      }
  else
    return 3;
}

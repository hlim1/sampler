#include <glib-object.h>
#include "report.h"
#include "g-object-unref-types.h"


void gObjectUnrefReport(const unsigned char *signature,
			unsigned count, const GObjectUnrefTuple tuples[])
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

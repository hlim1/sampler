#include <bonobo/bonobo-generic-factory.h>
#include <bonobo/bonobo-main.h>
#include "uploader.h"


BonoboObject *builder(BonoboGenericFactory *factory,
		      const char *component_id,
		      gpointer closure)
{
  return BONOBO_OBJECT(sampler_uploader_new());
}


BONOBO_ACTIVATION_FACTORY("OAFIID:SamplerUploader_Factory:1.0",
			  "Sampler Uploader Factory", "0.1",
			  builder, 0);

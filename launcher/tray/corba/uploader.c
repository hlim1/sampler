#include <libbonobo.h>
#include "uploader.h"
#include "Sampler_Uploader.h"


static GObjectClass *uploader_parent_class;


static void impl_uploader_increment(PortableServer_Servant servant, CORBA_Environment *env)
{
  g_print("Uploader service: increment\n");
  SamplerUploader * const self = SAMPLER_UPLOADER(bonobo_object(servant));
  g_print("   self == %p\n", self);
}


static void impl_uploader_decrement(PortableServer_Servant servant, CORBA_Environment *env)
{
  g_print("Uploader service: decrement\n");
}


static void sampler_uploader_init(SamplerUploader *uploader)
{
  g_print("instance init\n");
  uploader->increment = 0;
  uploader->decrement = 0;
}


static void sampler_uploader_finalize(GObject *object)
{
  g_print("instance finalize\n");
  uploader_parent_class->finalize(object);
}


static void sampler_uploader_class_init(SamplerUploaderClass *klass)
{
  GObjectClass *object_class = (GObjectClass *) klass;
  POA_Sampler_Uploader__epv *epv = &klass->epv;

  g_print("class init\n");

  uploader_parent_class = g_type_class_peek_parent(klass);

  object_class->finalize = sampler_uploader_finalize;

  epv->increment = impl_uploader_increment;
  epv->decrement = impl_uploader_decrement;
}


BONOBO_TYPE_FUNC_FULL (SamplerUploader, Sampler_Uploader, BONOBO_TYPE_OBJECT, sampler_uploader);


SamplerUploader *sampler_uploader_new()
{
  return g_object_new(SAMPLER_TYPE_UPLOADER, 0);
}


void sampler_uploader_set_closures(SamplerUploader *self, GClosure *increment_closure, GClosure *decrement_closure)
{
  self->increment = increment_closure;
  self->decrement = decrement_closure;
}

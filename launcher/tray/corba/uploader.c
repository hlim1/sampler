#include <libbonobo.h>
#include "uploader.h"
#include "Sampler_Uploader.h"


static GObjectClass *uploader_parent_class;


static void impl_uploader_increment(PortableServer_Servant servant, CORBA_Environment *env)
{
  g_print("Uploader service: increment\n");
}


static void impl_uploader_decrement(PortableServer_Servant servant, CORBA_Environment *env)
{
  g_print("Uploader service: decrement\n");
}


static void uploader_init(Uploader *uploader)
{
  g_print("instance init\n");
  uploader->title = "hoopy frood";
}


static void uploader_finalize(GObject *object)
{
  g_print("instance finalize\n");
  uploader_parent_class->finalize(object);
}


static void uploader_class_init(UploaderClass *klass)
{
  GObjectClass *object_class = (GObjectClass *) klass;
  POA_Sampler_Uploader__epv *epv = &klass->epv;

  g_print("class init\n");

  uploader_parent_class = g_type_class_peek_parent(klass);

  object_class->finalize = uploader_finalize;

  epv->increment = impl_uploader_increment;
  epv->decrement = impl_uploader_decrement;
}


BONOBO_TYPE_FUNC_FULL (Uploader, Sampler_Uploader, BONOBO_TYPE_OBJECT, uploader);

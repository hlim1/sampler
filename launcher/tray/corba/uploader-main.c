#include <bonobo/bonobo-context.h>
#include <bonobo/bonobo-main.h>
#include "uploader.h"

int main(int argc, char *argv[])
{
  if (!bonobo_is_initialized())
    if (!bonobo_init(&argc, argv))
      g_error("Server could not initialize Bonobo");
  
  Uploader * const uploader = g_object_new(TYPE_UPLOADER, 0);
  if (!uploader) g_error("Server could not instantiate Uploader");
  
  const CORBA_Object obj = BONOBO_OBJREF(uploader);
  switch (bonobo_activation_register_active_server("OAFIID:SamplerUploader:1.0", obj, 0))
    {
    case Bonobo_ACTIVATION_REG_SUCCESS:
      g_print("server registration: success\n");
      break;
    case Bonobo_ACTIVATION_REG_NOT_LISTED:
      g_print("server registration: not listed\n");
      bonobo_object_unref(uploader);
      return 1;
    case Bonobo_ACTIVATION_REG_ALREADY_ACTIVE:
      g_print("server registration: already active\n");
      return 2;
    case Bonobo_ACTIVATION_REG_ERROR:
      g_print("server registration: error\n");
      return 3;
    default:
      g_print("server registration: unknown\n");
      return 4;
    }

  bonobo_running_context_auto_exit_unref(BONOBO_OBJECT(uploader));

  g_print("Server entering bonobo_main()\n");
  bonobo_main();
  g_print("Server returned from bonobo_main()\n");

  return bonobo_debug_shutdown();
}

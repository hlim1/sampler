#include <bonobo/bonobo-exception.h>
#include <bonobo/bonobo-main.h>
#include <bonobo/bonobo-moniker-util.h>
#include <bonobo/bonobo-object.h>
#include <unistd.h>
#include "Sampler_Uploader.h"


int main(int argc, char *argv[])
{
  CORBA_Environment env;

  if (!bonobo_is_initialized())
    if (!bonobo_init(&argc, argv))
      g_error("Client could not initialize Bonobo");
  
  bonobo_activate();

  const Sampler_Uploader server = bonobo_get_object("OAFIID:SamplerUploader:1.0", "Sampler/Uploader", 0);
  CORBA_exception_init(&env);
  if (server == CORBA_OBJECT_NIL)
    {
      char * const err = bonobo_exception_get_text(&env);
      g_warning("Client could not instantiate Uploader: %s\n", err);
      return bonobo_debug_shutdown();
    }
  CORBA_exception_free(&env);

  sleep(2);

  CORBA_exception_init(&env);
  bonobo_object_release_unref(server, &env);
  if (BONOBO_EX(&env))
    {
      char * const err = bonobo_exception_get_text(&env);
      g_warning("%s\n", err);
      g_free(err);
    }
  CORBA_exception_free(&env);

  return bonobo_debug_shutdown();
}

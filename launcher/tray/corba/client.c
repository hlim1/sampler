#include <bonobo/bonobo-exception.h>
#include <bonobo/bonobo-main.h>
#include <bonobo/bonobo-moniker-util.h>
#include <bonobo/bonobo-object.h>
#include "Sampler_Uploader.h"


int main(int argc, char *argv[])
{
  if (!bonobo_is_initialized())
    if (!bonobo_init(&argc, argv))
      g_error("Client could not initialize Bonobo");
  
  bonobo_activate();
  const Sampler_Uploader server = bonobo_get_object("OAFIID:SamplerUploader:1.0", "Sampler/Uploader", 0);
  if (server == CORBA_OBJECT_NIL)
    {
      g_warning("Client could not instantiate Uploader\n");
      return bonobo_debug_shutdown();
    }

  bonobo_object_dup_ref(server, 0);

  {
    CORBA_Environment env;
    CORBA_exception_init(&env);
    Sampler_Uploader_increment(server, &env);
    if (BONOBO_EX(&env))
      {
	char * const err = bonobo_exception_get_text(&env);
	g_warning("Client exception occured: %s\n", err);
	g_free(err);
      }
    CORBA_exception_free(&env);
  }

  {
    CORBA_Environment env;
    CORBA_exception_init(&env);
    Sampler_Uploader_increment(server, &env);
    if (BONOBO_EX(&env))
      {
	char * const err = bonobo_exception_get_text(&env);
	g_warning("Client exception occured: %s\n", err);
	g_free(err);
      }
    CORBA_exception_free(&env);
  }

  {
    CORBA_Environment env;
    CORBA_exception_init(&env);
    Sampler_Uploader_decrement(server, &env);
    if (BONOBO_EX(&env))
      {
	char * const err = bonobo_exception_get_text(&env);
	g_warning("Client exception occured: %s\n", err);
	g_free(err);
      }
    CORBA_exception_free(&env);
  }

  bonobo_object_release_unref(server, 0);
  return bonobo_debug_shutdown();
}

#include <config.h>

#include <assert.h>
#include <gsl/gsl_randist.h>
#include <limits.h>
#include "acyclic.h"
#include "countdown.h"


const void * const providesLibAcyclic;

double density;
void *generator;
static gsl_rng *gen;

static int initCount;


__attribute__((constructor)) static void initialize()
{
  if (!initCount++)
    {
      const char * const environ = getenv("SAMPLER_SPARSITY");
      if (environ)
	{
	  char *end;
	  const double sparsity = strtod(environ, &end);
	  if (*end != '\0')
	    {
	      fprintf(stderr, "countdown/acyclic: trailing garbage in $SAMPLER_SPARSITY: %s", end);
	      exit(2);
	    }
	  else if (sparsity < 1)
	    {
	      fputs("countdown/acyclic: $SAMPLER_SPARSITY must be at least 1", stderr);
	      exit(2);
	    }
	  else
	    {
	      density = 1 / sparsity;
	      generator = gen = gsl_rng_alloc(gsl_rng_env_setup());
	      nextEventCountdown = getNextEventCountdown();
	    }
	}
    }
}
  

__attribute__((destructor)) static void finalize()
{
  if (!--initCount)
    {
      assert(!generator == !gen);

      if (gen)
	{
	  gsl_rng_free(gen);
	  generator = gen = 0;
	}
    }
}

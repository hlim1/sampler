#include <config.h>

#include <assert.h>
#include <gsl/gsl_randist.h>
#include <limits.h>
#include "acyclic.h"
#include "countdown.h"
#include "lifetime.h"


const void * const SAMPLER_REENTRANT(providesLibAcyclic);
int acyclicInitCount;

double acyclicDensity;
const gsl_rng_type * generatorType;
SAMPLER_THREAD_LOCAL void *acyclicGenerator;


void initialize_thread()
{
  acyclicGenerator = gsl_rng_alloc(generatorType);
  nextEventCountdown = getNextEventCountdown();
}


__attribute__((constructor)) static void initialize()
{
  if (!acyclicInitCount++)
    {
      const char * const environ = getenv("SAMPLER_SPARSITY");
      if (environ)
	{
	  char *end;
	  const double sparsity = strtod(environ, &end);
	  if (*end != '\0')
	    {
	      fprintf(stderr, "countdown/acyclic: trailing garbage in $SAMPLER_SPARSITY: %s\n", end);
	      exit(2);
	    }
	  else if (sparsity < 1)
	    {
	      fputs("countdown/acyclic: $SAMPLER_SPARSITY must be at least 1\n", stderr);
	      exit(2);
	    }
	  else
	    {
	      const char * const environ = getenv("SAMPLER_SEED");
	      generatorType = gsl_rng_env_setup();

	      if (environ)
		{
		  char *end;
		  gsl_rng_default_seed = strtoul(environ, &end, 0);
		  if (*end != '\0')
		    {
		      fprintf(stderr, "countdown/acyclic: trailing garbage in $SAMPLER_SEED: %s\n", end);
		      exit(2);
		    }
		}
	      
	      acyclicDensity = 1 / sparsity;
	      initialize_thread();
	    }
	}
    }
}


void finalize_thread()
{
  if (acyclicGenerator)
    {
      gsl_rng_free(acyclicGenerator);
      acyclicGenerator = 0;
    }
}
  

__attribute__((destructor)) static void finalize()
{
  if (!--acyclicInitCount)
    finalize_thread();
}

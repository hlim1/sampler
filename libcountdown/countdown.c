#include <config.h>

#include <assert.h>
#include <gsl/gsl_randist.h>
#include <limits.h>
#include "countdown.h"
#include "internals.h"


unsigned nextEventCountdown = UINT_MAX;


__attribute__((constructor)) static void initialize()
{
  const char * const environ = getenv("SAMPLER_SPARSITY");
  if (!environ)
    {
      fputs("countdown: must give sampling sparsity in $SAMPLER_SPARSITY\n", stderr);
      exit(2);
    }
  else
    {
      char *end;
      const double sparsity = strtod(environ, &end);
      if (*end != '\0')
	{
	  fprintf(stderr, "countdown: trailing garbage in $SAMPLER_SPARSITY: %s", end);
	  exit(2);
	}
      else if (sparsity < 1)
	{
	  fputs("countdown: $SAMPLER_SPARSITY must be at least 1", stderr);
	  exit(2);
	}
      else
	{
	  const double density = 1 / sparsity;
	  gsl_rng * const generator = gsl_rng_alloc(gsl_rng_env_setup());
	  precomputeCountdowns(density, generator);
	}
    }
}

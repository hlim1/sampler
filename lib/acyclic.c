#include <config.h>

#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "acyclic.h"
#include "countdown.h"
#include "lifetime.h"


const void * const SAMPLER_REENTRANT(providesLibAcyclic);
int acyclicInitCount;

double densityScale;
unsigned short seed[3];

SAMPLER_THREAD_LOCAL int sampling;
SAMPLER_THREAD_LOCAL struct drand48_data buffer;


void initialize_thread()
{
  sampling = seed48_r(seed, &buffer) >= 0;
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
	      if (environ)
		{
		  char *end;
		  union {
		    uint64_t all;
		    uint16_t triple[3];
		  } convert;

		  convert.all = strtoull(environ, &end, 0);
		  if (*end != '\0')
		    {
		      fprintf(stderr, "countdown/acyclic: trailing garbage in $SAMPLER_SEED: %s\n", end);
		      exit(2);
		    }

		  seed[0] = convert.triple[0];
		  seed[1] = convert.triple[1];
		  seed[2] = convert.triple[2];
		}
	      else
		seed[0] = seed[1] = seed[2] = 0;
	      
	      densityScale = 1 / log(1 - 1 / sparsity);
	      initialize_thread();
	    }

	  unsetenv("SAMPLER_SPARSITY");
	  unsetenv("SAMPLER_SEED");
	}
    }
}


void finalize_thread()
{
}


/**********************************************************************/


unsigned getNextEventCountdown()
{
  if (__builtin_expect(sampling, 1))
    {
      double real;
      const int error = drand48_r(&buffer, &real);
      if (__builtin_expect(error >= 0, 1))
	return log(real) * densityScale + 1;
    }

  return UINT_MAX;
}

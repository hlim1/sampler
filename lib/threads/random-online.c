#include <config.h>

#include <assert.h>
#include <limits.h>
#include <math.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "countdown.h"
#include "lifetime.h"
#include "once.h"
#include "random-online.h"


const void * const samplerFeatureRandom;
const void * const samplerFeatureRandomOnline;

double densityScale;
unsigned short samplerSeed[3];
FILE *samplerEntropy;

SAMPLER_THREAD_LOCAL int sampling;
SAMPLER_THREAD_LOCAL struct drand48_data samplerRandomBuffer;

sampler_once_t randomOnlineInitOnce = SAMPLER_ONCE_INIT;


void initialize_thread()
{
  if (samplerEntropy)
    {
      unsigned short seed[3];
      if (fread(seed, sizeof(seed), 1, samplerEntropy) == 1)
	sampling = seed48_r(seed, &samplerRandomBuffer) >= 0;
    }
  else
    sampling = seed48_r(samplerSeed, &samplerRandomBuffer) >= 0;

  nextEventCountdown = getNextEventCountdown();
}


static void finalize()
{
  if (samplerEntropy)
    {
      fclose(samplerEntropy);
      samplerEntropy = 0;
    }
}


static void initializeOnce()
{
  const char * const environ = getenv("SAMPLER_SPARSITY");
  if (environ)
    {
      char *end;
      const double sparsity = strtod(environ, &end);
      if (*end != '\0')
	{
	  fprintf(stderr, "trailing garbage in $SAMPLER_SPARSITY: %s\n", end);
	  exit(2);
	}
      else if (sparsity < 1)
	{
	  fputs("$SAMPLER_SPARSITY must be at least 1\n", stderr);
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
		  fprintf(stderr, "trailing garbage in $SAMPLER_SEED: %s\n", end);
		  exit(2);
		}

	      samplerSeed[0] = convert.triple[0];
	      samplerSeed[1] = convert.triple[1];
	      samplerSeed[2] = convert.triple[2];
	    }
	  else
	    {
	      atexit(finalize);
	      samplerEntropy = fopen("/dev/urandom", "r");
	    }

	  densityScale = 1 / log(1 - 1 / sparsity);
	  initialize_thread();
	}

      unsetenv("SAMPLER_SPARSITY");
      unsetenv("SAMPLER_SEED");
    }
  else
    fputs("$SAMPLER_SPARSITY is not set; CBI data collection disabled\n", stderr);
}


__attribute__((constructor)) static void initialize()
{
  sampler_once(&randomOnlineInitOnce, initializeOnce);
}


/**********************************************************************/


int getNextEventCountdown()
{
  if (__builtin_expect(sampling, 1))
    while (1)
      {
	double real;
	const int error = drand48_r(&samplerRandomBuffer, &real);
	if (__builtin_expect(error < 0, 0))
	  break;
	if (__builtin_expect(real != 0., 1))
	  return log(real) * densityScale + 1;
      }

  return INT_MAX;
}

#define _GNU_SOURCE		/* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <config.h>

#include <assert.h>
#include <limits.h>
#include <math.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "acyclic.h"
#include "countdown.h"
#include "lifetime.h"
#include "lock.h"


const void * const SAMPLER_REENTRANT(providesLibAcyclic);
int acyclicInitCount;

double densityScale;
unsigned short seed[3];
FILE *entropy;

SAMPLER_THREAD_LOCAL int sampling;
SAMPLER_THREAD_LOCAL struct drand48_data buffer;

pthread_mutex_t acyclicLock = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;


void initialize_thread()
{
  if (entropy)
    {
      unsigned short seed[3];
      if (fread(seed, sizeof(seed), 1, entropy) == 1)
	sampling = seed48_r(seed, &buffer) >= 0;
    }
  else
    sampling = seed48_r(seed, &buffer) >= 0;

  nextEventCountdown = getNextEventCountdown();
}


static void finalize()
{
  CRITICAL_REGION(acyclicLock, {
    if (entropy)
      {
	fclose(entropy);
	entropy = 0;
      }
  });
}


__attribute__((constructor)) static void initialize()
{
  CRITICAL_REGION(acyclicLock, {
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
		  {
		    atexit(finalize);
		    entropy = fopen("/dev/urandom", "r");
		  }
	      
		densityScale = 1 / log(1 - 1 / sparsity);
		initialize_thread();
	      }

	    unsetenv("SAMPLER_SPARSITY");
	    unsetenv("SAMPLER_SEED");
	  }
      }
  });
}


/**********************************************************************/


int getNextEventCountdown()
{
  if (__builtin_expect(sampling, 1))
    while (1)
      {
	double real;
	const int error = drand48_r(&buffer, &real);
	if (__builtin_expect(error < 0, 0))
	  break;
	if (__builtin_expect(real != 0., 1))
	  return log(real) * densityScale + 1;
      }

  return INT_MAX;
}

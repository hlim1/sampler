#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "countdown.h"
#include "lifetime.h"
#include "once.h"
#include "random-fixed.h"


const void * const samplerFeatureRandom;
const void * const samplerFeatureRandomFixed;

int randomFixedCountdown;

sampler_once_t randomFixedInitOnce = SAMPLER_ONCE_INIT;


void initialize_thread()
{
  nextEventCountdown = getNextEventCountdown();
}


static void initializeOnce()
{
  const char * const environ = getenv("SAMPLER_SPARSITY");
  if (environ)
    {
      char *end;
      randomFixedCountdown = strtol(environ, &end, 0);
      if (*end != '\0')
	{
	  fprintf(stderr, "trailing garbage in $SAMPLER_SPARSITY: %s\n", end);
	  exit(2);
	}
      else if (randomFixedCountdown < 1)
	{
	  fputs("$SAMPLER_SPARSITY must be at least 1\n", stderr);
	  exit(2);
	}

      initialize_thread();
      unsetenv("SAMPLER_SPARSITY");
    }
}


__attribute__((constructor)) static void initialize()
{
  sampler_once(&randomFixedInitOnce, initializeOnce);
}

#include <config.h>

#include <assert.h>
#include <gsl/gsl_randist.h>
#include "acyclic.h"
#include "countdown.h"
#include "internals.h"


double density;
void *generator;
static gsl_rng *gen;


void precomputeCountdowns(double density_, gsl_rng *generator_)
{
  density = density_;
  assert(!generator && !gen);
  generator = gen = generator_;
  nextEventCountdown = getNextCountdown();
}
  

__attribute__((destructor)) static void shutdown()
{
  assert(generator && gen);
  gsl_rng_free(gen);
  generator = gen = 0;
}

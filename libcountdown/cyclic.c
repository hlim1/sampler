#include <gsl/gsl_randist.h>
#include "countdown.h"
#include "cyclic.h"
#include "internals.h"


#define PRECOMPUTE_COUNT 1024

unsigned precomputedCountdowns[PRECOMPUTE_COUNT];
unsigned nextCountdownSlot = 0;


void precomputeCountdowns(double density, gsl_rng * const generator)
{
  int slot = PRECOMPUTE_COUNT;
  while (slot--)
    precomputedCountdowns[slot] = gsl_ran_geometric(generator, density);

  gsl_rng_free(generator);
  nextEventCountdown = getNextCountdown();
}

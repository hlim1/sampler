#include <config.h>

#include <assert.h>
#include <gsl/gsl_randist.h>
#include <limits.h>


int main()
{
  unsigned long long total = 0;
  unsigned trials = 0;
  gsl_rng * const generator = gsl_rng_alloc(gsl_rng_env_setup());
  unsigned saturations = 0;

  while (1)
    {
      const unsigned next = gsl_ran_geometric(generator, 1/1000000000.);
      if (next == UINT_MAX) ++saturations;
      assert(total + next > total);
      total += next;
      ++trials;
      printf("%u\t%u\t%u\t%Lu\t%f\n", saturations, trials, next, total, total / (double) trials);
    }
}

/*
 * Compile like this:
 *
 *   % gcc -O3 -o downsample downsample.c `gsl-config --libs`
 *
 * Note the backticks.
 */


#include <gsl/gsl_randist.h>
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[])
{
  const double probability = argc == 2 ? atof(argv[1]) : 0.;
  
  if (probability <= 0.)
    {
      fprintf(stderr, "Usage: %s <probability>\n", argv[0]);
      return 2;
    }
  else
    {
      gsl_rng * const generator = gsl_rng_alloc(gsl_rng_env_setup());

      while (!feof(stdin))
	{
	  unsigned int trials;
	  if (scanf("%u", &trials) == 1)
	    printf("%u\n", gsl_ran_binomial(generator, probability, trials));
	}

      gsl_rng_free(generator);
      return 0;
    }
}

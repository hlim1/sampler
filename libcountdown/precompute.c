#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "acyclic.h"
#include "cyclic-size.h"


unsigned nextEventCountdown;


static void writeCountdown(FILE *outfile)
{
  fwrite(&nextEventCountdown, sizeof(nextEventCountdown), 1, outfile);
}


static void writeEnv(FILE *outfile, const char ident[], const char envar[])
{
  fprintf(outfile, "$%s: %s $", ident, getenv(envar));
}


int main(int argc, char *argv[])
{
  if (argc != 2)
    {
      fprintf(stderr, "Usage: %s <outfile>\n", argv[0]);
      exit(2);
    }
  else
    {
      const char * const filename = argv[1];
      FILE * const outfile = fopen(filename, "w");
      if (!outfile)
	{
	  fprintf(stderr, "precompute: cannot open \"%s\" for writing: %s\n", filename, strerror(errno));
	  exit(1);
	}
      else
	{
	  int slot = PRECOMPUTE_COUNT;
	  while (slot--)
	    {
	      writeCountdown(outfile);
	      nextEventCountdown = getNextCountdown();
	    }

	  nextEventCountdown = 0;
	  writeCountdown(outfile);
	  writeEnv(outfile, "SamplerSparsity", "SAMPLER_SPARSITY");
	  writeEnv(outfile, "GslRngType", "GSL_RNG_TYPE");
	  writeEnv(outfile, "GslRngSeed", "GSL_RNG_SEED");
	  fclose(outfile);
	}
    }

  return 0;
}

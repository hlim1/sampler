#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include "daikount.h"


const struct Invariant *invariants;


static const char *logFilename()
{
  const char * const env = getenv("SAMPLER_FILE");

  if (!env)
    fputs("logger: not recording samples; no $SAMPLER_FILE given in environment\n", stderr);

  return env;
}


static void dumpInvariants(int signum)
{
  const char * const filename = logFilename();

  if (filename)
    {
      FILE * const logFile = fopen(filename, "w");

      if (!logFile)
	perror("logger: fopen error");
      else
	{
	  const struct Invariant *invariant;

	  fprintf(logFile, "%d\n", signum);

	  for (invariant = invariants; invariant; invariant = invariant->next)
	    fprintf(logFile, "%s\t%u\t%s\t%s\t%s\t%u\t%u\t%u\t%u\n",
		    invariant->file, invariant->line, invariant->function,
		    invariant->left, invariant->right, invariant->id,
		    invariant->counters[0], invariant->counters[1],
		    invariant->counters[2]);

	  if (fclose(logFile)) perror("logger: fclose error");
	}
    }
}



static void handleSignal(int signum)
{
  static volatile sig_atomic_t handling = 0;

  if (handling) raise(signum);
  
  handling = 1;
  dumpInvariants(signum);

  signal(signum, SIG_DFL);
  raise(signum);
}


__attribute__((constructor)) static void initialize()
{
  if (logFilename())
    {
      signal(SIGABRT, handleSignal);
      signal(SIGBUS, handleSignal);
      signal(SIGFPE, handleSignal);
      signal(SIGSEGV, handleSignal);
      signal(SIGTRAP, handleSignal);
    }
}


__attribute__((destructor)) static void shutdown()
{
  dumpInvariants(0);
}

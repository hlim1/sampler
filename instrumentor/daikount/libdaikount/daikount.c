#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include "daikount.h"


static FILE *logFile;

const struct Invariant *invariants;


__attribute__((destructor)) static void shutdown()
{
  if (logFile)
    {
      const struct Invariant *invariant;
      for (invariant = invariants; invariant; invariant = invariant->next)
	fprintf(logFile, "%s\t%u\t%s\t%s\t%s\t%u\t%u\t%u\t%u\n",
		invariant->file, invariant->line, invariant->function,
		invariant->left, invariant->right, invariant->id,
		invariant->counters[0], invariant->counters[1],
		invariant->counters[2]);

      if (fclose(logFile)) perror("logger: fclose error");
      logFile = 0;
    }
}


static void handleSignal(int signum)
{
  static volatile sig_atomic_t handling = 0;

  if (handling) raise(signum);
  
  handling = 1;
  shutdown();

  signal(signum, SIG_DFL);
  raise(signum);
}


__attribute__((constructor)) static void initialize()
{
  const char * const filename = getenv("SAMPLER_FILE");
  
  if (filename)
    {
      logFile = fopen(filename, "w");
      if (!logFile) perror("logger: fopen error");
    }
  else
    fputs("logger: not recording samples; no $SAMPLER_FILE given in environment\n", stderr);

  signal(SIGABRT, handleSignal);
  signal(SIGBUS, handleSignal);
  signal(SIGFPE, handleSignal);
  signal(SIGSEGV, handleSignal);
  signal(SIGTRAP, handleSignal);
}

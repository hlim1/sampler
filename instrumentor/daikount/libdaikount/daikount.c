#include <malloc.h>
#include <obstack.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "daikount.h"


const struct Invariant *invariants;


#define obstack_chunk_alloc malloc
#define obstack_chunk_free free


static const char *logFileName()
{
  return getenv("SAMPLER_FILE");
}


static FILE *openLogFile()
{
  struct obstack obstack;
  obstack_init(&obstack);

  const char *start = logFileName();
  if (!start)
    return 0;
  
  while (*start)
    {
      const char *end = strstr(start, "$$");
      if (end)
	{
	  obstack_grow(&obstack, start, end - start);
	  obstack_printf(&obstack, "%d", getpid());
	  start = end + 2;
	}
      else
	break;
    }

  const int leftovers = strlen(start);
  obstack_grow0(&obstack, start, leftovers);
  
  char * const filename = (char *) obstack_finish(&obstack);
  FILE * const logFile = fopen(filename, "w");
  obstack_free(&obstack, filename);
  return logFile;
}


static void dumpInvariants(int signum)
{
  FILE * const logFile = openLogFile();
  if (logFile)
    {
      fprintf(logFile, "%d\n", signum);

      const struct Invariant *invariant;
      for (invariant = invariants; invariant; invariant = invariant->next)
	fprintf(logFile, "%s\t%u\t%s\t%s\t%s\t%u\t%u\t%u\t%u\n",
		invariant->file, invariant->line, invariant->function,
		invariant->left, invariant->right, invariant->id,
		invariant->counters[0], invariant->counters[1],
		invariant->counters[2]);

      if (fclose(logFile))
	perror("logger: fclose error");
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
  if (logFileName())
    {
      signal(SIGABRT, handleSignal);
      signal(SIGBUS, handleSignal);
      signal(SIGFPE, handleSignal);
      signal(SIGSEGV, handleSignal);
      signal(SIGTRAP, handleSignal);
    }
  else
    {
      fputs("logger: no $SAMPLER_FILE given in environment\n", stderr);
      return;
    }
}


__attribute__((destructor)) static void shutdown()
{
  dumpInvariants(0);
}

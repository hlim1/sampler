#include <errno.h>
#include <obstack.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include "report.h"
#include "requires.h"

#define obstack_chunk_alloc malloc
#define obstack_chunk_free free


const void * const providesLibReport;


static const char *logFileName()
{
  return getenv("SAMPLER_FILE");
}


static FILE *openLogFile()
{
  const char *start = logFileName();
  struct obstack obstack;

  if (!start)
    return 0;
  
  obstack_init(&obstack);
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

  {
    const int leftovers = strlen(start);
    obstack_grow0(&obstack, start, leftovers);
  }
  
  {
    char * const filename = (char *) obstack_finish(&obstack);
    FILE * const logFile = fopen(filename, "w");
    obstack_free(&obstack, filename);
    return logFile;
  }
}


static void dumpSamplesReport(FILE * const logFile)
{
  fputs("<report id=\"samples\">\n", logFile);
  dumpSamples(logFile);
  fputs("</report>\n", logFile);
  fflush(logFile);
}


static void dumpDebugInfo(FILE * const logFile)
{
  const char * const debugger = getenv("SAMPLER_DEBUGGER");
  if (debugger)
    {
      const pid_t pid = fork();
      switch (pid)
	{
	case -1:
	  break;

	case 0:
	  if (dup2(fileno(logFile), STDOUT_FILENO) == -1)
	    perror("dup2 failed");
	  else
	    {
	      char arg[21];
	      snprintf(arg, sizeof(arg), "%d", getppid());
	      execl(debugger, debugger, arg, 0);
	      perror("debugger exec failed");
	    }
	  
	  exit(errno);

	default:
	  waitpid(pid, 0, 0);
	}
    }
}


static void finalize()
{
  FILE * const logFile = openLogFile();
  if (logFile)
    {
      dumpSamplesReport(logFile);
      fclose(logFile);
    }
}


static void handleSignal(int signum)
{
  signal(signum, SIG_DFL);

  FILE * const logFile = openLogFile();
  if (logFile)
    {
      dumpSamplesReport(logFile);
      dumpDebugInfo(logFile);
      fclose(logFile);
    }

  raise(signum);
}


__attribute__((constructor)) static void initialize()
{
  if (logFileName())
    {
      atexit(finalize);
      signal(SIGABRT, handleSignal);
      signal(SIGBUS, handleSignal);
      signal(SIGFPE, handleSignal);
      signal(SIGSEGV, handleSignal);
      signal(SIGTRAP, handleSignal);
    }
}

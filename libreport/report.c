#include <errno.h>
#include <obstack.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include "anchor.h"
#include "lock.h"
#include "report.h"
#include "requires.h"
#include "unit.h"

#define obstack_chunk_alloc malloc
#define obstack_chunk_free free


const void * const providesLibReport;

unsigned reportInitCount;
FILE *reportFile;


static void openReportFile()
{
  const char *start = getenv("SAMPLER_FILE");
  struct obstack obstack;

  if (!start)
    return;
  
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
    reportFile = fopen(filename, "w");
    if (reportFile)
      fputs("<report id=\"samples\">\n", reportFile);
    obstack_free(&obstack, filename);
  }
}


static void closeReportFile()
{
  fclose(reportFile);
  reportFile = 0;
}


/**********************************************************************/


static void reportAllCompilationUnits()
{
  if (reportFile)
    {
      while (compilationUnitAnchor.next != &compilationUnitAnchor)
	unregisterCompilationUnit(compilationUnitAnchor.next);
      
      fputs("</report>\n", reportFile);
    }
}


static void reportDebugInfo()
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
	  if (dup2(fileno(reportFile), STDOUT_FILENO) == -1)
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
  CRITICAL_REGION({
    if (reportFile)
      {
	reportAllCompilationUnits();
	closeReportFile();
      }
  });
}


static void handleSignal(int signum)
{
  signal(signum, SIG_DFL);

  CRITICAL_REGION({
    if (reportFile)
      {
	reportAllCompilationUnits();
	reportDebugInfo();
	fclose(reportFile);
	reportFile = 0;
      }
  });

  raise(signum);
}


__attribute__((constructor)) static void initialize()
{
  CRITICAL_REGION({
    if (!reportInitCount++)
      {
	openReportFile();
	if (reportFile)
	  {
	    atexit(finalize);
	    signal(SIGABRT, handleSignal);
	    signal(SIGBUS, handleSignal);
	    signal(SIGFPE, handleSignal);
	    signal(SIGSEGV, handleSignal);
	    signal(SIGTRAP, handleSignal);
	  }
      }
  });
}

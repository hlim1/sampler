#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include "anchor.h"
#include "lock.h"
#include "report.h"
#include "unit.h"


const void * const providesLibReport;

unsigned reportInitCount;
FILE *reportFile;


static void openReportFile()
{
  const char *filename = getenv("SAMPLER_FILE");
  reportFile = fopen(filename, "w");
  unsetenv("SAMPLER_FILE");

  if (reportFile)
    fputs("<report id=\"samples\">\n", reportFile);
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

  fflush(reportFile);
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

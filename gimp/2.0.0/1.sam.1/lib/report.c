#define _GNU_SOURCE		/* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include "lock.h"
#include "registry.h"
#include "report.h"


const void * const providesLibReport;

unsigned reportInitCount;
FILE *reportFile;

pthread_mutex_t reportLock = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;


static void closeOnExec(int fd)
{
  int flags = fcntl(fileno(reportFile), F_GETFD, 0);

  if (flags >= 0)
    {
      flags |= FD_CLOEXEC;
      fcntl(fd, F_SETFD, flags);
    }
}


static void openReportFile()
{
  const char *envar;

  if ((envar = getenv("SAMPLER_REPORT_FD")))
    {
      char *tail;
      const int fd = strtol(envar, &tail, 0);
      if (*tail == '\0')
	{
	  reportFile = fdopen(fd, "w");
	  closeOnExec(fd);
	}
    }

  else if ((envar = getenv("SAMPLER_FILE")))
    {
      reportFile = fopen(envar, "w");
      closeOnExec(fileno(reportFile));
    }

  unsetenv("SAMPLER_REPORT_FD");
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
      samplerUnregisterAllUnits();
      fputs("</report>\n", reportFile);
      fflush(reportFile);
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
  CRITICAL_REGION(reportLock, {
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

  CRITICAL_REGION(reportLock, {
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
  CRITICAL_REGION(reportLock, {
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


void samplesBegin(const unsigned char *signature, const char scheme[])
{
  fprintf(reportFile,
	  "<samples unit=\""
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "%02x%02x%02x%02x%02x%02x%02x%02x"
	  "\" scheme=\"%s\">\n",
	  signature[ 0], signature[ 1], signature[ 2], signature[ 3],
	  signature[ 4], signature[ 5], signature[ 6], signature[ 7],
	  signature[ 8], signature[ 9], signature[10], signature[11],
	  signature[12], signature[13], signature[14], signature[15],
	  scheme);
}


void samplesDump1(unsigned count, const unsigned counts[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\n", counts[scan]);
}


void samplesDump2(unsigned count, const unsigned tuples[][2])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1]);
}


void samplesDump3(unsigned count, const unsigned tuples[][3])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);
}


void samplesDump4(unsigned count, const unsigned tuples[][4])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(reportFile, "%u\t%u\t%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2],
	    tuples[scan][3]);
}


void samplesEnd()
{
  fputs("</samples>\n", reportFile);
}

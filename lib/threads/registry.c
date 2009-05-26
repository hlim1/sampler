#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../registry.h"
#include "../report.h"
#include "verbose.h"
#include<fcntl.h>


struct cbi_Unit cbi_unitAnchor = { &cbi_unitAnchor,
				   &cbi_unitAnchor,
				   0 };

static unsigned unitCount;

static pthread_mutex_t unitLock __attribute__((unused)) = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;

/* cci */
static void lockReportFile()
{
  if(cbi_reportFile) 
    {
      struct flock fl; 
      fl.l_type   = F_WRLCK; 
      fl.l_whence = SEEK_SET;
      fl.l_start  = 0;       
      fl.l_len    = 0;       
      fl.l_pid    = getpid();
      if(fcntl(fileno(cbi_reportFile), F_SETLKW, &fl) ==-1)
	VERBOSE("%s(): Error locking the file\n", __FUNCTION__);
    }
}

 /* cci */
static void unlockReportFile()
{
  if(cbi_reportFile)
    {
      struct flock fl;
      fl.l_type   = F_UNLCK;  
      fl.l_whence = SEEK_SET;
      fl.l_start  = 0;       
      fl.l_len    = 0;       
      fl.l_pid    = getpid();
      if(fcntl(fileno(cbi_reportFile), F_SETLKW, &fl) ==-1)
	VERBOSE("%s(): Error unlocking the file\n", __FUNCTION__);

    }
}

void cbi_registerUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(unitLock, {
    if (!unit->next && !unit->prev)
      {
	++unitCount;
	unit->prev = &cbi_unitAnchor;
	unit->next = cbi_unitAnchor.next;
	cbi_unitAnchor.next->prev = unit;
	cbi_unitAnchor.next = unit;
      }
  });
}


void cbi_unregisterUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(unitLock, {
    if (unit->next && unit->prev)
      {
	unit->prev->next = unit->next;
	unit->next->prev = unit->prev;
	unit->prev = unit->next = 0;

	if (unitCount)
	  {
	    if (cbi_reportFile)
	      {
		lockReportFile(); /*cci*/
		fflush(cbi_reportFile);
		fseek(cbi_reportFile, 0, SEEK_END);
		fputs( "<report id=\"samples\">\n", cbi_reportFile);
		unit->reporter();
		fputs("</report> \n", cbi_reportFile); 
		fflush(cbi_reportFile);
		unlockReportFile(); /*cci*/
	      }
	    --unitCount;
	  }
      }
  });
}


void cbi_unregisterAllUnits()
{
  CBI_CRITICAL_REGION(unitLock, {
    while (cbi_unitAnchor.next != &cbi_unitAnchor)
      cbi_unregisterUnit(cbi_unitAnchor.next);
  });
}

#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <fcntl.h>
#include <pthread.h>
#include "../registry.h"
#include "../report.h"
#include "lock.h"
#include "verbose.h"


struct cbi_Unit cbi_unitAnchor = { &cbi_unitAnchor,
				   &cbi_unitAnchor,
				   0 };

static unsigned unitCount;

static pthread_mutex_t unitLock __attribute__((unused)) = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;


/* cci */
static void changeLockReportFile(short lockType, const char gerund[])
{
  if (cbi_reportFile)
    {
      const struct flock flock = {
	.l_type   = lockType,
	.l_whence = SEEK_SET,
	.l_start  = 0,
	.l_len    = 0,
      };
      if (fcntl(fileno(cbi_reportFile), F_SETLKW, &flock) == -1)
	VERBOSE("%s(): Error %s the file\n", __FUNCTION__, gerund);
    }
}


/* cci */
static void lockReportFile()
{
  changeLockReportFile(F_WRLCK, "locking");
}


/* cci */
static void unlockReportFile()
{
  changeLockReportFile(F_UNLCK, "unlocking");
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

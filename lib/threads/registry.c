#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../registry.h"
#include "../report.h"


struct cbi_Unit cbi_unitAnchor = { &cbi_unitAnchor,
				   &cbi_unitAnchor,
				   0 };

unsigned cbi_unitCount;

pthread_mutex_t cbi_unitLock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;


void cbi_registerUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(cbi_unitLock, {
    if (!unit->next && !unit->prev)
      {
	++cbi_unitCount;
	unit->prev = &cbi_unitAnchor;
	unit->next = cbi_unitAnchor.next;
	cbi_unitAnchor.next->prev = unit;
	cbi_unitAnchor.next = unit;
      }
  });
}


void cbi_unregisterUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(cbi_unitLock, {
    if (unit->next && unit->prev)
      {
	unit->prev->next = unit->next;
	unit->next->prev = unit->prev;
	unit->prev = unit->next = 0;

	if (cbi_unitCount)
	  {
	    if (cbi_reportFile)
	      unit->reporter();

	    --cbi_unitCount;
	  }
      }
  });
}


void cbi_unregisterAllUnits()
{
  CBI_CRITICAL_REGION(cbi_unitLock, {
    while (cbi_unitAnchor.next != &cbi_unitAnchor)
      cbi_unregisterUnit(cbi_unitAnchor.next);
  });
}

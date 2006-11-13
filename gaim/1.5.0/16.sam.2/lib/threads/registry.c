#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../registry.h"
#include "../report.h"


struct SamplerUnit samplerUnitAnchor = { &samplerUnitAnchor,
					 &samplerUnitAnchor,
					 0 };

unsigned samplerUnitCount;

pthread_mutex_t samplerUnitLock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;


void samplerRegisterUnit(struct SamplerUnit *unit)
{
  CRITICAL_REGION(samplerUnitLock, {
    if (!unit->next && !unit->prev)
      {
	++samplerUnitCount;
	unit->prev = &samplerUnitAnchor;
	unit->next = samplerUnitAnchor.next;
	samplerUnitAnchor.next->prev = unit;
	samplerUnitAnchor.next = unit;
      }
  });
}


void samplerUnregisterUnit(struct SamplerUnit *unit)
{
  CRITICAL_REGION(samplerUnitLock, {
    if (unit->next && unit->prev)
      {
	unit->prev->next = unit->next;
	unit->next->prev = unit->prev;
	unit->prev = unit->next = 0;

	if (samplerUnitCount)
	  {
	    if (reportFile)
	      unit->reporter();

	    --samplerUnitCount;
	  }
      }
  });
}


void samplerUnregisterAllUnits()
{
  CRITICAL_REGION(samplerUnitLock, {
    while (samplerUnitAnchor.next != &samplerUnitAnchor)
      samplerUnregisterUnit(samplerUnitAnchor.next);
  });
}

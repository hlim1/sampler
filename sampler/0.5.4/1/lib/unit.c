#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "report.h"
#include "unit.h"


struct CompilationUnit compilationUnitAnchor = { &compilationUnitAnchor,
						 &compilationUnitAnchor,
						 "", 0, 0 };

unsigned compilationUnitCount;

pthread_mutex_t compilationUnitLock = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;


void registerCompilationUnit(struct CompilationUnit *unit)
{
  CRITICAL_REGION(compilationUnitLock, {
    if (!unit->next && !unit->prev)
      {
	++compilationUnitCount;
	unit->prev = &compilationUnitAnchor;
	unit->next = compilationUnitAnchor.next;
	compilationUnitAnchor.next->prev = unit;
	compilationUnitAnchor.next = unit;
      }
  });
}


void unregisterCompilationUnit(struct CompilationUnit *unit)
{
  CRITICAL_REGION(compilationUnitLock, {
    if (unit->next && unit->prev)
      {
	unit->prev->next = unit->next;
	unit->next->prev = unit->prev;
	unit->prev = unit->next = 0;

	if (compilationUnitCount)
	  {
	    if (reportFile) reportCompilationUnit(unit);
	    --compilationUnitCount;
	  }
      }
  });
}


void unregisterAllCompilationUnits()
{
  CRITICAL_REGION(compilationUnitLock, {
    while (compilationUnitAnchor.next != &compilationUnitAnchor)
      unregisterCompilationUnit(compilationUnitAnchor.next);
  });
}

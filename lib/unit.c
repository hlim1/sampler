#include "anchor.h"
#include "lock.h"
#include "report.h"
#include "unit.h"


struct CompilationUnit compilationUnitAnchor = { &compilationUnitAnchor,
						 &compilationUnitAnchor,
						 "", 0, 0 };

unsigned compilationUnitCount;


void registerCompilationUnit(struct CompilationUnit *unit)
{
  CRITICAL_REGION({
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
  CRITICAL_REGION({
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

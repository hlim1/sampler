#include "schemes/branches-unit.h"
#include "schemes/returns-unit.h"
#include "threads/countdown.h"
#include "threads/random-online.h"

static cbi_TupleCounter cbi_dummyCounters[0][1];

void cbi_dummyUsesToKeepDeclarations(void)
{
  cbi_nextEventCountdown = cbi_getNextEventCountdown();
  **cbi_branchesCounters = 0;
  **cbi_dummyCounters = 0;
  **cbi_returnsCounters = 0;
}

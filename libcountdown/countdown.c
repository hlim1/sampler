#include <assert.h>
#include <limits.h>
#include <stdlib.h>
#include "countdown.h"


unsigned nextLogCountdown = UINT_MAX;


__attribute__((constructor)) void resetCountdown()
{
  unsigned countUp = 1;
  
  while (random() % 4096 != 0)
    {
      ++countUp;
      if (countUp == 0)
      {
	countUp = UINT_MAX;
	break;
      }
    }

  nextLogCountdown = countUp;
}


void skipLog()
{
  assert(nextLogCountdown > 0);
  --nextLogCountdown;
}

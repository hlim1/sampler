#include <assert.h>
#include <limits.h>
#include <stdlib.h>
#include "countdown.h"


unsigned nextLogCountdown = UINT_MAX;


__attribute__((constructor)) void resetCountdown()
{
  unsigned countUp = 1;
  
  while (random() % (1 << 20) != 0)
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

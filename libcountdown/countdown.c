#include <assert.h>
#include <limits.h>
#include <stdlib.h>
#include "countdown.h"


unsigned nextLogCountdown = UINT_MAX;


unsigned resetCountdown()
{
  unsigned countUp = 1;
  
#if 0
  while (random() % (1 << 20) != 0)
    {
      ++countUp;
      if (countUp == 0)
      {
	countUp = UINT_MAX;
	break;
      }
    }
#endif

  return countUp;
}


__attribute__((constructor)) static void initialize()
{
  nextLogCountdown = resetCountdown();
}

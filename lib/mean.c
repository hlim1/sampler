#include <config.h>

#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include "countdown.h"
#include "random-online.h"


int main()
{
  unsigned long long total = 0;
  unsigned trials = 0;
  unsigned saturations = 0;

  while (1)
    {
      if (nextEventCountdown == INT_MAX) ++saturations;
      assert(total + nextEventCountdown > total);
      total += nextEventCountdown;
      ++trials;
      printf("%u\t%u\t%u\t%Lu\t%f\n", saturations, trials, nextEventCountdown, total, total / (double) trials);
      nextEventCountdown = getNextEventCountdown();
    }
}

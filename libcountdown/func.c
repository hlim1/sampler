#include <limits.h>
#include "cyclic.h"
#include "func.h"


const unsigned *nextFuncPrecomputed = 0;
unsigned nextFuncCountdown = UINT_MAX;
unsigned nextFuncSlot = 0;

static unsigned initCount;


__attribute__((constructor)) static void initialize()
{
  if (!initCount++)
    {
      nextFuncPrecomputed = loadCountdowns("SAMPLER_FUNC_COUNTDOWNS");
      nextFuncCountdown = getNextFuncCountdown();
    }
}


__attribute__((destructor)) static void finalize()
{
  if (!--initCount)
    unloadCountdowns(nextFuncPrecomputed);
}

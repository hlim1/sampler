#include <limits.h>
#include "cyclic.h"
#include "func.h"


const unsigned *nextFuncPrecomputed = 0;
unsigned nextFuncCountdown = UINT_MAX;
unsigned nextFuncSlot = 0;


__attribute__((constructor)) static void initialize()
{
  nextFuncPrecomputed = loadCountdowns("SAMPLER_FUNC_COUNTDOWNS");
  nextFuncCountdown = getNextFuncCountdown();
}


__attribute__((destructor)) static void finalize()
{
  unloadCountdowns(nextFuncPrecomputed);
}

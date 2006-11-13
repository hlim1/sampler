#include "once.h"
#include "random.h"
#include "report.h"
#include "verbose.h"


sampler_once_t samplerInitializeOnce = SAMPLER_ONCE_INIT;


static void
initializeOnce()
{
  samplerInitializeVerbose();

  samplerInitializeRandom();
  samplerInitializeReport();
}


__attribute__((constructor)) void
samplerInitialize()
{
  sampler_once(&samplerInitializeOnce, initializeOnce);
}

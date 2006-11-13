#include "verbose.h"


int samplerVerbose;


void
samplerInitializeVerbose()
{
  samplerVerbose = !!getenv("SAMPLER_VERBOSE");
}

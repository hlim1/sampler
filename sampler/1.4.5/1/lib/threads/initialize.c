#include "once.h"
#include "random.h"
#include "report.h"
#include "verbose.h"


cbi_once_t cbi_initializeOnce = CBI_ONCE_INIT;


static void
initializeOnce()
{
  cbi_initializeVerbose();

  cbi_initializeRandom();
  cbi_initializeReport();
}


__attribute__((constructor)) void
cbi_initialize()
{
  cbi_once(&cbi_initializeOnce, initializeOnce);
}

#define _GNU_SOURCE /* For RTLD_NEXT */

#include <dlfcn.h>
#include <unistd.h>
#include "random.h"
#include "report.h"
#include "verbose.h"

pid_t fork(void)
{
  static typeof(fork) *real_fork;
  if (!real_fork)
    real_fork = dlsym(RTLD_NEXT, __func__);

  pid_t pid = real_fork();
  if (pid == 0)
    {
      VERBOSE("in child");
      cbi_uninitializeReport();
      cbi_initializeRandom();
    }

  return pid;
}

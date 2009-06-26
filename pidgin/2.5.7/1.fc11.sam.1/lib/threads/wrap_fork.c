#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include "random.h"
#include "report.h"
#include "verbose.h"

typeof(fork) __real_fork;
typeof(fork) __wrap_fork;

pid_t __wrap_fork(void)
{
  pid_t pid = __real_fork();
  if(pid == 0)
    {
      VERBOSE("%s(): in child\n", __FUNCTION__);
      cbi_initializeRandom();
    }
  return pid;
}


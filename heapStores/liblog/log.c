#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

#include <countdown.h>


pid_t pid;


__attribute__((constructor, unused)) static void initialize()
{
  pid = getpid();
}


void logWrite(const char filename[], unsigned line,
	      const void *address, unsigned size,
	      const void *data __attribute__((unused)))
{
  if (nextLogCountdown > 0)
    skipLog();
  else
    {
      resetCountdown();
      
      fprintf(stderr, "%s:%u: (%d) writes %p for %u bytes\n",
	      filename, line, pid, address, size);
    }
}

#include <ctime>
#include <iostream>
#include <signal.h>
#include <sys/time.h>
#include <term.h>
#include <unistd.h>
#include "progress.h"


static const time_t beginning = time(0);

unsigned long long tasksCompleted;
volatile bool progressUpdateNeeded;


static const char *getcodes(char *name, const char *fallback)
{
  static const int setup __attribute__((unused)) = setupterm(0, 1, 0);
  const char * const result = tigetstr(name);
  switch ((intptr_t) result)
    {
    case -1:
    case 0:
      return fallback;
    default:
      return result;
    }
}


void displayProgress()
{
  static const char *cr = getcodes("cr", "");
  static const char *el = getcodes("el", "\n");
  
  const double elapsed = difftime(time(0), beginning);
  cout << cr << "progress: " << tasksCompleted << " sites in "
       << elapsed << " seconds; " << tasksCompleted / elapsed
       << " sites/second" << el << flush;
}


static void handleAlarm(int)
{
  progressUpdateNeeded = true;
}


void initializeAlarm()
{
  signal(SIGALRM, handleAlarm);
  
  struct itimerval interval;
  interval.it_interval.tv_sec = 1;
  interval.it_interval.tv_usec = 0;
  interval.it_value = interval.it_interval;
  
  setitimer(ITIMER_REAL, &interval, 0);
}

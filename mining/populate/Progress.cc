#include <term.h>
#include <unistd.h>
#include "Progress.h"


static const char *getcap(char name[], const char fallback[])
{
  static int init __attribute__((unused)) = setupterm(0, 1, 0);
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


static const char * const cr = getcap("cr", "");
static const char * const el = getcap("el", "\n");


Progress::Progress(const string &description, unsigned total)
  : description(description),
    total(total),
    current(0)
{
}


Progress::~Progress()
{
  cout << endl;
}


void Progress::bump()
{
  ++current;
  static unsigned priorPercent = 0;
  const unsigned percent = current * 100 / total;
  if (percent != priorPercent)
    {
      priorPercent = percent;
      cout << cr << description << ": " << current << " / " << total << " (" << percent << "%)" << el << flush;
    }
}

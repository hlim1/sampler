#include <limits.h>
#include "countdown.h"


SAMPLER_THREAD_LOCAL int nextEventCountdown = INT_MAX;

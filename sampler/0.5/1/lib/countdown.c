#include <limits.h>
#include "countdown.h"


SAMPLER_THREAD_LOCAL unsigned nextEventCountdown = UINT_MAX;

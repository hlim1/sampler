#include <assert.h>
#include <stdarg.h>
#include <stdio.h>

#include <countdown.h>
#include "log.h"


void samplerLog(const char *format, ...)
{
  assert(nextLogCountdown > 0);
  --nextLogCountdown;

  if (nextLogCountdown == 0)
    {
      resetCountdown();
      
      {
	va_list arguments;
	va_start(arguments, format);
	vfprintf(stderr, format, arguments);
	va_end(arguments);
      }
    }
}

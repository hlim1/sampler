#include <stdarg.h>
#include <stdio.h>

#include <countdown.h>
#include "log.h"


void logVars(const char *format, ...)
{
  skipLog();

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

#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h

#include "../libcountdown/countdown.h"
#include "primitive.h"


void logTableau(const void *, unsigned);


inline unsigned resetCountdown()
{
  const unsigned result = getNextCountdown();
  logTableau(&result, sizeof result);
  return result;
}


#endif /* !INCLUDE_liblog_log_h */

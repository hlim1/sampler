#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h



extern const char logSignature[];

#pragma cilnoremove("requireLogSignature")
static const char * const requireLogSignature __attribute__((unused)) = logSignature;


void logTableau(const void *, unsigned);


static inline unsigned resetCountdown() __attribute__((no_instrument_function));

static inline unsigned resetCountdown()
{
  const unsigned result = getNextCountdown();
  logTableau(&result, sizeof result);
  return result;
}


#endif /* !INCLUDE_liblog_log_h */

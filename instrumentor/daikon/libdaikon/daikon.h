#ifndef INCLUDE_libdaikon_daikon_h
#define INCLUDE_libdaikon_daikon_h


static inline unsigned resetCountdown() __attribute__((no_instrument_function));

static inline unsigned resetCountdown()
{
  return getNextCountdown();
}


void checkInvariant(const char [], const char [], char);


#endif /* !INCLUDE_libdaikon_daikon_h */

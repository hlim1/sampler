#ifndef INCLUDE_libdecure_decure_h
#define INCLUDE_libdecure_decure_h


static inline unsigned resetCountdown() __attribute__((no_instrument_function));

static inline unsigned resetCountdown()
{
  return getNextCountdown();
}


#endif /* !INCLUDE_libdecure_decure_h */

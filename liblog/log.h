#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h


extern const char logSignature[];


#ifdef CIL
#pragma cilnoremove("requireLogSignature")
#endif

static const char * const requireLogSignature __attribute__((unused)) = logSignature;


#ifdef CIL
#pragma sampler_exclude_function("logTableau")
#endif

void logTableau(const void *, unsigned) __attribute__((no_instrument_function));


#endif /* !INCLUDE_liblog_log_h */

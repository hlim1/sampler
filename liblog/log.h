#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h


extern unsigned nextLogCountdown;


void skipWrite();

void logWrite(const char *, unsigned, const void *, unsigned, const void *);


#endif /* !INCLUDE_liblog_log_h */

#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h



extern const char logSignature[];

#pragma cilnoremove("requireLogSignature")
static const char * const requireLogSignature __attribute__((unused)) = logSignature;


void logTableau(const void *, unsigned);


#endif /* !INCLUDE_liblog_log_h */

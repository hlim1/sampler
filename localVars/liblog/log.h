#ifndef INCLUDE_localVars_liblog_log_h
#define INCLUDE_localVars_liblog_log_h


void logPointer(const char *, unsigned, const char *, const void *);

void logDouble(const char *, unsigned, const char *, double);
void logLongDouble(const char *, unsigned, const char *, long double);

void logChar(const char *, unsigned, const char *, char);

void logShort(const char *, unsigned, const char *, short);
void logUnsignedShort(const char *, unsigned, const char *, unsigned short);

void logInt(const char *, unsigned, const char *, int);
void logUnsignedInt(const char *, unsigned, const char *, unsigned int);

void logLong(const char *, unsigned, const char *, long);
void logUnsignedLong(const char *, unsigned, const char *, unsigned long);

void logLongLong(const char *, unsigned, const char *, long long);
void logUnsignedLongLong(const char *, unsigned, const char *, unsigned long long);


#endif /* !INCLUDE_localVars_liblog_log_h */

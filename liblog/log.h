#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h


void logSiteBegin(const char *, unsigned);
void logSiteEnd();

void logChar(const char *, char);
void logSignedChar(const char *, signed char);
void logUnsignedChar(const char *, unsigned char);
void logInt(const char *, int);
void logUnsignedInt(const char *, unsigned);
void logShort(const char *, short);
void logUnsignedShort(const char *, unsigned short);
void logLong(const char *, long);
void logUnsignedLong(const char *, unsigned long);
void logLongLong(const char *, long long);
void logUnsignedLongLong(const char *, unsigned long long);
void logFloat(const char *, float);
void logDouble(const char *, double);
void logLongDouble(const char *, long double);
void logPointer(const char *, const void *);


#endif /* !INCLUDE_liblog_log_h */

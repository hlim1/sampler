#ifndef INCLUDE_liblog_log_h
#define INCLUDE_liblog_log_h

#include "storage.h"


void logSiteBegin(const char *, unsigned);


__attribute__((no_instrument_function)) extern inline
void logSiteEnd()
{
  storeNull();
}


__attribute__((no_instrument_function)) extern inline
void logChar(const char *name, char value)
{
  storeValue(name, Char, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logSignedChar(const char *name, signed char value)
{
  storeValue(name, SignedChar, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logUnsignedChar(const char *name, unsigned char value)
{
  storeValue(name, UnsignedChar, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logInt(const char *name, int value)
{
  storeValue(name, Int, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logUnsignedInt(const char *name, unsigned value)
{
  storeValue(name, UnsignedInt, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logShort(const char *name, short value)
{
  storeValue(name, Short, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logUnsignedShort(const char *name, unsigned short value)
{
  storeValue(name, UnsignedShort, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logLong(const char *name, long value)
{
  storeValue(name, Long, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logUnsignedLong(const char *name, unsigned long value)
{
  storeValue(name, UnsignedLong, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logLongLong(const char *name, long long value)
{
  storeValue(name, LongLong, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logUnsignedLongLong(const char *name, unsigned long long value)
{
  storeValue(name, UnsignedLongLong, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logFloat(const char *name, float value)
{
  storeValue(name, Float, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logDouble(const char *name, double value)
{
  storeValue(name, Double, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logLongDouble(const char *name, long double value)
{
  storeValue(name, LongDouble, &value, sizeof(value));
}


__attribute__((no_instrument_function)) extern inline
void logPointer(const char *name, const void * value)
{
  storeValue(name, Pointer, &value, sizeof(value));
}


#endif /* !INCLUDE_liblog_log_h */


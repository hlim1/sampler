#include <stdio.h>
#include "log.h"


void logPointer(const char *file, unsigned line, const char *selector, const void *value)
{
  fprintf(stderr, "%s:%u: %s == %p\n", file, line, selector, value);
}


void logDouble(const char *file, unsigned line, const char *selector, double value)
{
  fprintf(stderr, "%s:%u: %s == %g\n", file, line, selector, value);
}

void logLongDouble(const char *file, unsigned line, const char *selector, long double value)
{
  fprintf(stderr, "%s:%u: %s == %Lg\n", file, line, selector, value);
}


void logChar(const char *file, unsigned line, const char *selector, char value)
{
  fprintf(stderr, "%s:%u: %s == %c\n", file, line, selector, value);
}


void logShort(const char *file, unsigned line, const char *selector, short value)
{
  fprintf(stderr, "%s:%u: %s == %hd\n", file, line, selector, value);
}

void logUnsignedShort(const char *file, unsigned line, const char *selector, unsigned short value)
{
  fprintf(stderr, "%s:%u: %s == %hu\n", file, line, selector, value);
}


void logInt(const char *file, unsigned line, const char *selector, int value)
{
  fprintf(stderr, "%s:%u: %s == %d\n", file, line, selector, value);
}

void logUnsignedInt(const char *file, unsigned line, const char *selector, unsigned int value)
{
  fprintf(stderr, "%s:%u: %s == %u\n", file, line, selector, value);
}


void logLong(const char *file, unsigned line, const char *selector, long value)
{
  fprintf(stderr, "%s:%u: %s == %ld\n", file, line, selector, value);
}

void logUnsignedLong(const char *file, unsigned line, const char *selector, unsigned long value)
{
  fprintf(stderr, "%s:%u: %s == %lu\n", file, line, selector, value);
}


void logLongLong(const char *file, unsigned line, const char *selector, long long value)
{
  fprintf(stderr, "%s:%u: %s == %lld\n", file, line, selector, value);
}

void logUnsignedLongLong(const char *file, unsigned line, const char *selector, unsigned long long value)
{
  fprintf(stderr, "%s:%u: %s == %llu\n", file, line, selector, value);
}

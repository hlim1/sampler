#ifndef INCLUDE_libdaikon_daikon_h
#define INCLUDE_libdaikon_daikon_h

#include <stdint.h>


struct Invariant
{
  const struct Invariant *next;

  unsigned counters[3];

  const char * const file;
  const unsigned line;
  const char * const function;
  const char * const left;
  const char * const right;
  const unsigned id;
};


void registerInvariant(struct Invariant *);


#endif /* !INCLUDE_libdaikon_daikon_h */

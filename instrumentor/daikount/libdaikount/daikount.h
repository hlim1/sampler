#ifndef INCLUDE_libdaikon_daikon_h
#define INCLUDE_libdaikon_daikon_h


#ifdef CIL
#pragma cilnoremove("struct Invariant")
#pragma cilnoremove("registerInvariant")
#pragma cilnoremove("unregisterInvariant")
#endif


struct Invariant
{
  struct Invariant *prev;
  struct Invariant *next;

  unsigned counters[3];

  const char * const file;
  const unsigned line;
  const char * const function;
  const char * const left;
  const char * const right;
  const unsigned id;
};


extern struct Invariant anchor;


static inline void registerInvariant(struct Invariant *) __attribute__((no_instrument_function));

static inline void registerInvariant(struct Invariant *invariant)
{
  invariant->prev = &anchor;
  invariant->next = anchor.next;
  anchor.next->prev = invariant;
  anchor.next = invariant;
}


static inline void unregisterInvariant(struct Invariant *) __attribute__((no_instrument_function));

static inline void unregisterInvariant(struct Invariant *invariant)
{
  invariant->prev->next = invariant->next;
  invariant->next->prev = invariant->prev;
}


#endif /* !INCLUDE_libdaikon_daikon_h */

#ifndef INCLUDE_libbranches_branches_h
#define INCLUDE_libbranches_branches_h


#ifdef CIL
#pragma cilnoremove("struct BranchProfile")
#pragma cilnoremove("registerBranchProfile")
#pragma cilnoremove("unregisterBranchProfile")
#endif


struct BranchProfile
{
  struct BranchProfile *prev;
  struct BranchProfile *next;
  
  unsigned counters[2];

  const char * const file;
  const unsigned line;
  const char * const function;
  const char * const condition;
  const unsigned id;
};


extern struct BranchProfile anchor;


static inline void registerBranchProfile(struct BranchProfile *) __attribute__((no_instrument_function));

static inline void registerBranchProfile(struct BranchProfile *profile)
{
  profile->prev = &anchor;
  profile->next = anchor.next;
  anchor.next->prev = profile;
  anchor.next = profile;
}


static inline void unregisterBranchProfile(struct BranchProfile *) __attribute__((no_instrument_function));

static inline void unregisterBranchProfile(struct BranchProfile *profile)
{
  if (profile->prev) profile->prev->next = profile->next;
  if (profile->next) profile->next->prev = profile->prev;
}


#endif /* !INCLUDE_libbranches_branches_h */

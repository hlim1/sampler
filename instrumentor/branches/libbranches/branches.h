#ifndef INCLUDE_libbranches_branches_h
#define INCLUDE_libbranches_branches_h


struct BranchProfile
{
  const struct BranchProfile *next;

  unsigned counters[2];

  const char * const file;
  const unsigned line;
  const char * const function;
  const char * const condition;
  const unsigned id;
};


static inline void registerBranchProfile(struct BranchProfile *) __attribute__((no_instrument_function));

static inline void registerBranchProfile(struct BranchProfile *profile)
{
  extern const struct BranchProfile *profiles;

  profile->next = profiles;
  profiles = profile;
}


#endif /* !INCLUDE_libbranches_branches_h */

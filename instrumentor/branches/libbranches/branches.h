#ifndef INCLUDE_libbranches_branches_h
#define INCLUDE_libbranches_branches_h


typedef unsigned BranchCounters[2];


struct BranchProfile
{
  struct BranchProfile *prev;
  struct BranchProfile *next;
  
  const unsigned char signature[128 / 8];
  const unsigned count;
  BranchCounters sites[];
};


void registerBranchProfile(struct BranchProfile *);
void unregisterBranchProfile(struct BranchProfile *);


#endif /* !INCLUDE_libbranches_branches_h */

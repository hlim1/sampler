#ifndef INCLUDE_libbranches_branches_h
#define INCLUDE_libbranches_branches_h


typedef unsigned CounterTuple[2];


struct CompilationUnit
{
  struct CompilationUnit *prev;
  struct CompilationUnit *next;
  
  const unsigned char signature[128 / 8];
  const unsigned count;
  CounterTuple * const tuples;
};


void registerCompilationUnit(struct CompilationUnit *);
void unregisterCompilationUnit(struct CompilationUnit *);


#endif /* !INCLUDE_libbranches_branches_h */

#ifndef INCLUDE_libscalar_pairs_scalar_pairs_h
#define INCLUDE_libscalar_pairs_scalar_pairs_h


typedef unsigned CounterTuple[3];


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


#endif /* !INCLUDE_libscalar_pairs_scalar_pairs_h */

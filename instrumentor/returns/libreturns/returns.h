#ifndef INCLUDE_libreturns_returns_h
#define INCLUDE_libreturns_returns_h


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


#endif /* !INCLUDE_libreturns_returns_h */

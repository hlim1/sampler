#ifndef INCLUDE_libreport_unit_h
#define INCLUDE_libreport_unit_h


struct CounterTuple;


struct CompilationUnit
{
  struct CompilationUnit *prev;
  struct CompilationUnit *next;
  
  const unsigned char signature[128 / 8];
  const unsigned count;
  struct CounterTuple * const tuples;
};


#ifdef CIL
#pragma sampler_assume_weightless("registerCompilationUnit")
#pragma sampler_assume_weightless("unregisterCompilationUnit")
#endif

void registerCompilationUnit(struct CompilationUnit *);
void unregisterCompilationUnit(struct CompilationUnit *);


#endif /* !INCLUDE_libreport_unit_h */

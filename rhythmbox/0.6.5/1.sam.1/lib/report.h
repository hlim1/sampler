#ifndef INCLUDE_libreport_report_h
#define INCLUDE_libreport_report_h

#include <stdio.h>

struct CompilationUnit;


extern FILE *reportFile;


void reportCompilationUnit(const struct CompilationUnit *);


#endif /* !INCLUDE_libreport_report_h */

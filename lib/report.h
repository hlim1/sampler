#ifndef INCLUDE_libreport_report_h
#define INCLUDE_libreport_report_h

#include <stdio.h>


extern FILE *reportFile;


void samplesBegin(const unsigned char *, const char []);
void samplesDump2(unsigned, const unsigned [][2]);
void samplesDump3(unsigned, const unsigned [][3]);
void samplesEnd();


#endif /* !INCLUDE_libreport_report_h */

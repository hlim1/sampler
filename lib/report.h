#ifndef INCLUDE_libreport_report_h
#define INCLUDE_libreport_report_h

#include <stdio.h>


extern FILE *reportFile;

struct SamplerTuple1;
struct SamplerTuple2;
struct SamplerTuple3;
struct SamplerTuple4;


void samplesBegin(const unsigned char *, const char []);
void samplesDump1(unsigned, const struct SamplerTuple1 []);
void samplesDump2(unsigned, const struct SamplerTuple2 []);
void samplesDump3(unsigned, const struct SamplerTuple3 []);
void samplesDump4(unsigned, const struct SamplerTuple4 []);
void samplesEnd();


#endif /* !INCLUDE_libreport_report_h */

#ifndef INCLUDE_sampler_bounds_h
#define INCLUDE_sampler_bounds_h

#include "../signature.h"


void boundsReportBegin(const SamplerUnitSignature);
void boundsReportEnd();

void boundDumpSignedChar(signed char, signed char);
void boundDumpUnsignedChar(unsigned char, unsigned char);
void boundDumpSignedShort(signed short, signed short);
void boundDumpUnsignedShort(unsigned short, unsigned short);
void boundDumpSignedInt(signed int, signed int);
void boundDumpUnsignedInt(unsigned int, unsigned int);
void boundDumpSignedLong(signed long, signed long);
void boundDumpUnsignedLong(unsigned long, unsigned long);
void boundDumpSignedLongLong(signed long long, signed long long);
void boundDumpUnsignedLongLong(unsigned long long, unsigned long long);
void boundDumpPointer(const void *, const void *);


#ifdef CIL
#pragma cilnoremove("boundDumpSignedChar")
#pragma cilnoremove("boundDumpUnsignedChar")
#pragma cilnoremove("boundDumpSignedShort")
#pragma cilnoremove("boundDumpUnsignedShort")
#pragma cilnoremove("boundDumpSignedInt")
#pragma cilnoremove("boundDumpUnsignedInt")
#pragma cilnoremove("boundDumpSignedLong")
#pragma cilnoremove("boundDumpUnsignedLong")
#pragma cilnoremove("boundDumpSignedLongLong")
#pragma cilnoremove("boundDumpUnsignedLongLong")
#pragma cilnoremove("boundDumpPointer")
#endif /* CIL */


#endif /* !INCLUDE_sampler_bounds_h */

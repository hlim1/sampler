#ifndef INCLUDE_sampler_bounds_types_h
#define INCLUDE_sampler_bounds_types_h

#include "signature.h"

void boundsReportBegin(const SamplerUnitSignature);
void boundsReportEnd();

void boundDumpChar(char, char);
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
#pragma cilnoremove("boundDumpChar")
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


#endif /* !INCLUDE_sampler_bounds_types_h */

#ifndef INCLUDE_libreport_requires_h
#define INCLUDE_libreport_requires_h


extern const void * const providesLibReport;

#ifdef CIL
#pragma cilnoremove("requiresLibReport")
static const void * const requiresLibReport = &providesLibReport;
#endif


#endif /* !INCLUDE_libreport_requires_h */

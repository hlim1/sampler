#ifndef INCLUDE_sampler_trace_h
#define INCLUDE_sampler_trace_h

#include "trace-lttng.h"
#include "unit-signature.h"

#ifdef CIL
#pragma cilnoremove("cbi_tracepoint")
#pragma sampler_assume_weightless("cbi_tracepoint")
#endif /* CIL */

void cbi_tracepoint( const cbi_UnitSignature unit, const char * scheme, unsigned long site, unsigned long selector );

#endif /* !INCLUDE_sampler_trace_h */

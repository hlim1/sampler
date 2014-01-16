#ifndef INCLUDE_sampler_trace_h
#define INCLUDE_sampler_trace_h

#include "trace-lttng.h"
#include "unit-signature.h"

static inline void cbi_tracepoint(const char * scheme, const int site, const int selector) {
  tracepoint(cbi_trace, tp, cbi_unitSignature, scheme, site, selector);
}

#ifdef CIL
#pragma cilnoremove("cbi_tracepoint")
#pragma sampler_exclude_function("cbi_tracepoint")
#pragma sampler_exclude_function("__tracepoint_cb_cbi_trace___tp")
#pragma sampler_exclude_function("__tracepoints__destroy")
#pragma sampler_exclude_function("__tracepoints__init")
#endif /* CIL */

#endif /* !INCLUDE_sampler_trace_h */

#undef TRACEPOINT_PROVIDER
#define TRACEPOINT_PROVIDER cbi_trace

#undef TRACEPOINT_INCLUDE_FILE
#define TRACEPOINT_INCLUDE_FILE trace-lttng.h

#ifdef TRACEPOINT_HEADER_MULTI_READ
#undef INCLUDE_sampler_trace_lttng_h
#endif /* TRACEPOINT_HEADER_MULTI_READ */

#ifndef INCLUDE_sampler_trace_lttng_h
#define INCLUDE_sampler_trace_lttng_h

#include <lttng/tracepoint.h>

TRACEPOINT_EVENT(
  cbi_trace,
  tp,
  TP_ARGS( char *, cbi_unit, char *, cbi_scheme, int, cbi_site, int, cbi_selector ),
  TP_FIELDS(
    ctf_array( char, unit, cbi_unit, 16 )
    ctf_array_text( char, scheme, cbi_scheme, 1 )
    ctf_integer( int, site, cbi_site )
    ctf_integer( int, selector, cbi_selector )
  )
)

#endif /* !INCLUDE_sampler_trace_lttng_h */

#include <lttng/tracepoint-event.h>

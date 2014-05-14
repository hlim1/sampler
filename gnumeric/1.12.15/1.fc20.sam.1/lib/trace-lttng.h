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
  TP_ARGS( const unsigned char *, _unit, const char *, _scheme, unsigned long, _site, unsigned long, _selector ),
  TP_FIELDS(
    ctf_array( const unsigned char, unit, _unit, 16 )
    ctf_array_text( const char, scheme, _scheme, 1 )
    ctf_integer( unsigned long, site, _site )
    ctf_integer( unsigned long, selector, _selector )
  )
)

#endif /* !INCLUDE_sampler_trace_lttng_h */

#include <lttng/tracepoint-event.h>

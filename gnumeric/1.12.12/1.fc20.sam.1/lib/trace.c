#define TRACEPOINT_CREATE_PROBES
#define TRACEPOINT_DEFINE
#define TRACEPOINT_PROBE_DYNAMIC_LEAKAGE

#include "trace.h"

void cbi_tracepoint( const cbi_UnitSignature unit, const char * scheme, unsigned long site, unsigned long selector ) {
  tracepoint(cbi_trace, tp, unit, scheme, site, selector);
}

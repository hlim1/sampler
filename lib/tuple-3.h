#ifndef INCLUDE_sampelr_tuple_3_h
#define INCLUDE_sampelr_tuple_3_h

#include "timestamps.h"


struct SamplerTuple3 {
  SAMPLER_TIMESTAMP_FIELD;
  unsigned count[3];
};


#endif /* !INCLUDE_sampelr_tuple_3_h */

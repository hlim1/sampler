#ifndef INCLUDE_sampelr_tuple_4_h
#define INCLUDE_sampelr_tuple_4_h

#include "timestamps.h"


struct SamplerTuple4 {
  SAMPLER_TIMESTAMP_FIELD;
  unsigned count[4];
};


#endif /* !INCLUDE_sampelr_tuple_4_h */

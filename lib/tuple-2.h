#ifndef INCLUDE_sampelr_tuple_2_h
#define INCLUDE_sampelr_tuple_2_h

#include "timestamps.h"


struct SamplerTuple2 {
  SAMPLER_TIMESTAMP_FIELD;
  unsigned count[2];
};


#endif /* !INCLUDE_sampelr_tuple_2_h */

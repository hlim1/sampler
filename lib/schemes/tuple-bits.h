#ifndef INCLUDE_sampler_tuple_bits_h
#define INCLUDE_sampler_tuple_bits_h


#ifndef CBI_TUPLE_COUNTER_BITS
#define CBI_TUPLE_COUNTER_BITS natural
#endif

#if CBI_TUPLE_COUNTER_BITS == natural
typedef unsigned cbi_TupleCounter;
#define CBI_TUPLE_COUNTER_FORMAT "u"
#endif // CBI_TUPLE_COUNTER_BITS == natural

#if CBI_TUPLE_COUNTER_BITS == 32
#include <inttypes.h>
typedef uint32_t cbi_TupleCounter;
#define CBI_TUPLE_COUNTER_FORMAT PRIu32
#endif // CBI_TUPLE_COUNTER_BITS == 32

#if CBI_TUPLE_COUNTER_BITS == 64
#include <inttypes.h>
typedef uint64_t cbi_TupleCounter;
#define CBI_TUPLE_COUNTER_FORMAT PRIu64
#endif // CBI_TUPLE_COUNTER_BITS == 64


#endif /* !INCLUDE_sampler_tuple_bits_h */

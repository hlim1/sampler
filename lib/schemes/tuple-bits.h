#ifndef INCLUDE_sampler_tuple_bits_h
#define INCLUDE_sampler_tuple_bits_h


#ifndef CBI_TUPLE_COUNTER_BITS
typedef unsigned cbi_TupleCounter;
#  define CBI_TUPLE_COUNTER_FORMAT "u"
#  define CBI_TUPLE_COUNTER_X86_INC_OPERAND_SUFFIX "l"

#else
#  if CBI_TUPLE_COUNTER_BITS == 32
#    include <inttypes.h>
typedef uint32_t cbi_TupleCounter;
#    define CBI_TUPLE_COUNTER_FORMAT PRIu32
#    define CBI_TUPLE_COUNTER_X86_INC_OPERAND_SUFFIX "l"

#  elif CBI_TUPLE_COUNTER_BITS == 64
#    include <inttypes.h>
typedef uint64_t cbi_TupleCounter;
#    define CBI_TUPLE_COUNTER_FORMAT PRIu64
#    define CBI_TUPLE_COUNTER_X86_INC_OPERAND_SUFFIX "q"

#  else
#    error "unexpected value for CBI_TUPLE_COUNTER_BITS; should defined as 32 or 64 or left undefined"
#  endif
#endif


#endif /* !INCLUDE_sampler_tuple_bits_h */

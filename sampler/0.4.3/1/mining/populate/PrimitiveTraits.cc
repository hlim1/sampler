#include <stdint.h>
#include "PrimitiveTraits.h"


const char PrimitiveTraits<int8_t>::name[] = "int8";
const char PrimitiveTraits<uint8_t>::name[] = "uint8";
const char PrimitiveTraits<int16_t>::name[] = "int16";
const char PrimitiveTraits<uint16_t>::name[] = "uint16";
const char PrimitiveTraits<int32_t>::name[] = "int32";
const char PrimitiveTraits<uint32_t>::name[] = "uint32";
const char PrimitiveTraits<int64_t>::name[] = "int64";
const char PrimitiveTraits<uint64_t>::name[] = "uint64";

const char PrimitiveTraits<float>::name[] = "float32";
const char PrimitiveTraits<double>::name[] = "float64";
const char PrimitiveTraits<long double>::name[] = "float96";

const char PrimitiveTraits<const void *>::name[] = "pointer32";

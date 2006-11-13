#define _ISOC99_SOURCE 1
#include <math.h>
#include <stdlib.h>
#include "samples.h"
#include "float-kinds.h"


void floatKindsReport(const SamplerUnitSignature signature,
		      unsigned count, const SamplerTuple9 tuples[])
{
  samplesBegin(signature, "float-kinds");
  samplesDump9(count, tuples);
  samplesEnd();
}


enum Classification { NegativeInfinite,
		      NegativeNormal,
		      NegativeSubnormal,
		      NegativeZero,
		      NotANumber,
		      PositiveZero,
		      PositiveSubnormal,
		      PositiveNormal,
		      PositiveInfinite };


unsigned
floatKindsClassify(long double value)
{
  switch (fpclassify(value))
    {
    case FP_NAN:
      return NotANumber;
    case FP_INFINITE:
      return signbit(value) ? NegativeInfinite : PositiveInfinite;
    case FP_ZERO:
      return signbit(value) ? NegativeZero : PositiveZero;
    case FP_SUBNORMAL:
      return signbit(value) ? NegativeSubnormal : PositiveSubnormal;
    case FP_NORMAL:
      return signbit(value) ? NegativeNormal : PositiveNormal;
    default:
      abort();
    }
}

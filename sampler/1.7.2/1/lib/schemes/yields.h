#ifndef INCLUDE_sampler_yields_h
#define INCLUDE_sampler_yields_h
/*is this ok to do?*/
#include<pthread.h>
#include<stdio.h>
#include "../signature.h"
#include "tuple-2.h"


int cbi_yield(int);


void cbi_yieldsReport(const cbi_UnitSignature, unsigned, const cbi_Tuple2 []);




#endif /* !INCLUDE_sampler_yields_h */

#ifndef INCLUDE_sampler_fun_reentries_h
#define INCLUDE_sampler_fun_reentries_h

#include <pthread.h>
#include "../signature.h"
#include "tuple-2.h"


void cbi_funReentriesReport(const cbi_UnitSignature, unsigned, const cbi_Tuple2 []);


void cbi_funre_lock();

void cbi_funre_unlock();


#endif /* !INCLUDE_sampler_fun_reentries_h */

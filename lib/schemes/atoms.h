#ifndef INCLUDE_sampler_atoms_h
#define INCLUDE_sampler_atoms_h
/*is this ok to do?*/
#include<pthread.h>
#include<stdio.h>
#include "../signature.h"
#include "tuple-2.h"

void cbi_atoms_yield();

int cbi_thread_self();

void cbi_atomsReport(const cbi_UnitSignature, unsigned, const cbi_Tuple2 []);




#endif /* !INCLUDE_sampler_atoms_h */

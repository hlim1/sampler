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

void cbi_atoms_lock();

void cbi_atoms_unlock();

//////////TODO: shouldn't be here



//insert (key,val) unsigned into the dictionary
unsigned int cbi_dict_insert(unsigned int key, unsigned int val);

// lookup the key in the dictionary
// if found, return 1 and update val
// else return 0
unsigned int cbi_dict_lookup(unsigned int key, unsigned int *val);

// clear the dictionary
void cbi_dict_clear();

void cbi_dict_test_and_set(unsigned int key, 
			   unsigned int expectedVal, 
			   unsigned int *isDifferent,
			   unsigned int *isStale);


#endif /* !INCLUDE_sampler_atoms_h */

#ifndef INCLUDE_sampler_atoms_h
#define INCLUDE_sampler_atoms_h
/*is this ok to do?*/
#include <pthread.h>
#include <stdio.h>
#include "../signature.h"
#include "tuple-2.h"

extern int cbi_atomsSampling;
extern __thread int cbi_atomsInitiator;

extern pthread_mutex_t cbi_atomsLock;

void cbi_atomsReport(const cbi_UnitSignature, unsigned, const cbi_Tuple2 []);

//////////TODO: shouldn't be here



/* //insert (key,val) unsigned into the dictionary */
/* unsigned int cbi_dict_insert(unsigned int key, unsigned int val); */

/* // lookup the key in the dictionary */
/* // if found, return 1 and update val */
/* // else return 0 */
/* unsigned int cbi_dict_lookup(unsigned int key, unsigned int *val); */

// clear the dictionary
void cbi_dict_clear();

int cbi_dict_test_and_insert(unsigned long int key,
			     unsigned long int expectedVal,
			     int *isDifferent,
			     int *isStale);

/* void cbi_dict_test_and_set(unsigned int key,  */
/* 				   unsigned int expectedVal,  */
/* 				   int *isDifferent, */
/* 				   int *isStale); */


#endif /* !INCLUDE_sampler_atoms_h */

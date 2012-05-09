#ifndef INCLUDE_sampler_compareSwap_h
#define INCLUDE_sampler_compareSwap_h
/*is this ok to do?*/
#include <pthread.h>
#include <stdio.h>
#include "../signature.h"
#include "tuple-2.h"

/* thread global is sufficient */
extern __thread int cbi_compareSwapSampling;
extern __thread int cbi_compareSwapCounter;

void cbi_compareSwapReport(const cbi_UnitSignature, unsigned, const cbi_Tuple2 []);

//////////TODO: shouldn't be here



/* //insert (key,val) unsigned into the dictionary */
/* unsigned int cbi_dict_insert(unsigned int key, unsigned int val); */

/* // lookup the key in the dictionary */
/* // if found, return 1 and update val */
/* // else return 0 */
/* unsigned int cbi_dict_lookup(unsigned int key, unsigned int *val); */

// clear the dictionary
void cbi_dict_clear(void);

void cbi_dict_insert(unsigned long int key,
                    unsigned long int expectedVal);

int cbi_dict_test_and_insert(unsigned long int key,
		             unsigned long int expectedVal,
		             int *isDifferent,
		             int *isStale);

/* void cbi_dict_test_and_set(unsigned int key,  */
/* 				   unsigned int expectedVal,  */
/* 				   int *isDifferent, */
/* 				   int *isStale); */


#endif /* !INCLUDE_sampler_compareSwap_h */

#ifndef INCLUDE_sampler_registry_h
#define INCLUDE_sampler_registry_h

#include "signature.h"


struct SamplerUnit {
  struct SamplerUnit *next;
  struct SamplerUnit *prev;
  const unsigned char *signature;
  void (*reporter)(void);
};


void samplerRegisterUnit(struct SamplerUnit *);
void samplerUnregisterUnit(struct SamplerUnit *);

void samplerUnregisterAllUnits();


#endif /* !INCLUDE_sampler_registry_h */

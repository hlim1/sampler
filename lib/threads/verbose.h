#ifndef INCLUDE_sampler_lib_threads_verbose_h
#define INCLUDE_sampler_lib_threads_verbose_h

#include <stdio.h>


void samplerInitializeVerbose(void);

#define VERBOSE(format, ...)					\
  do								\
    {								\
      extern int samplerVerbose;				\
      if (__builtin_expect(samplerVerbose != 0, 0))		\
	fprintf(stderr, "CBI: " format, ## __VA_ARGS__);	\
    }								\
  while (0)


#endif /* !INCLUDE_sampler_lib_threads_verbose_h */

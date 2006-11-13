#ifndef INCLUDE_sampler_g_object_unref_types_h
#define INCLUDE_sampler_g_object_unref_types_h


typedef unsigned GObjectUnrefTuple[4];


void gObjectUnrefReport(const unsigned char *, unsigned, const GObjectUnrefTuple []);

unsigned gObjectUnrefClassify(void *);


#endif /* !INCLUDE_sampler_g_object_unref_types_h */

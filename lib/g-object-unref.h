#ifndef INCLUDE_sampler_g_object_unref_h
#define INCLUDE_sampler_g_object_unref_h


struct SamplerTuple4;


void gObjectUnrefReport(const unsigned char *, unsigned, const struct SamplerTuple4 []);

unsigned gObjectUnrefClassify(void *);


#endif /* !INCLUDE_sampler_g_object_unref_h */

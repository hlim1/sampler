#ifndef INCLUDE_sampler_blast_markers_h
#define INCLUDE_sampler_blast_markers_h


#pragma cilnoremove("blastMarker")
#pragma sampler_exclude_function("blastMarker")
static inline
void blastMarker(int siteId, int condition)
{
}


#pragma cilnoremove("blastTerminationMarker")
#pragma sampler_exclude_function("blastTerminationMarker")
static inline
void blastTerminationMarker()
{
}


#endif // !INCLUDE_sampler_blast_markers_h

#ifndef INCLUDE_sampler_blast_markers_h
#define INCLUDE_sampler_blast_markers_h


#pragma cilnoremove("cbi_blastMarker")
#pragma sampler_exclude_function("cbi_blastMarker")
static inline
void cbi_blastMarker(int siteId, int condition)
{
}


#pragma cilnoremove("cbi_blastTerminationMarker")
#pragma sampler_exclude_function("cbi_blastTerminationMarker")
static inline
void cbi_blastTerminationMarker()
{
}


#endif // !INCLUDE_sampler_blast_markers_h

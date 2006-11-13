#ifndef INCLUDE_sensitive_local_h
#define INCLUDE_sensitive_local_h

#ifdef SAMPLER_THREADS
#  define SAMPLER_THREAD_LOCAL __thread
#else
#  define SAMPLER_THREAD_LOCAL
#endif

#endif /* !INCLUDE_sensitive_local_h */

#ifndef INCLUDE_libthreads_threads_h
#define INCLUDE_libthreads_threads_h


#define SAMPLER_THREAD_LOCAL __thread
#define SAMPLER_REENTRANT(symbol) symbol ## _r
#define SAMPLER_REENTRANT_NAME(symbol) symbol "_r"
#define SAMPLER_THREADS


#endif /* !INCLUDE_libthreads_threads_h */

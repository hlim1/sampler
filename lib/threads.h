#ifndef INCLUDE_sampler_threads_h
#define INCLUDE_sampler_threads_h


#ifdef SAMPLER_THREADS

#define SAMPLER_THREAD_LOCAL __thread
#define SAMPLER_REENTRANT(symbol) symbol ## _r

#else  /* no threads */

#define SAMPLER_THREAD_LOCAL
#define SAMPLER_REENTRANT(symbol) symbol
#undef SAMPLER_THREADS

#endif /* no threads */


#endif /* !INCLUDE_sampler_threads_h */

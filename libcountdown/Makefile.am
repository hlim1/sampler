lib_LIBRARIES =	$(nothread_libs) $(thread_libs)

nothread_libs =					\
	libacyclic.a				\
	libcountdown.a				\
	libcyclic.a

cyclic = -DSAMPLER_CYCLIC
acyclic = -DSAMPLER_ACYCLIC

nothreads = -include $(top_srcdir)/libthreads/no-threads.h
libacyclic_a_SOURCES = acyclic.c acyclic.h countdown.h lifetime.h
libacyclic_a_CFLAGS = $(nothreads) -ffast-math
libcyclic_a_SOURCES = countdown.h cyclic.c cyclic.h cyclic-size.h
libcyclic_a_CFLAGS = $(nothreads)
libcountdown_a_SOURCES = countdown.c countdown.h
libcountdown_a_CFLAGS = $(nothreads)

if HAVE_THREAD_STORAGE
thread_libs =					\
	libacyclic_r.a				\
	libcountdown_r.a			\
	libcyclic_r.a

threads = -pthread -include $(top_srcdir)/libthreads/threads.h
libacyclic_r_a_SOURCES = $(libacyclic_a_SOURCES) hijack.c
libacyclic_r_a_CFLAGS = $(threads) $(acyclic) -ffast-math
libcyclic_r_a_SOURCES = $(libcyclic_a_SOURCES) hijack.c
libcyclic_r_a_CFLAGS = $(threads) $(cyclic)
libcountdown_r_a_SOURCES = $(libcountdown_a_SOURCES)
libcountdown_r_a_CFLAGS = $(threads)
endif

libexec_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_CFLAGS = $(nothreads)
precompute_LDADD = libacyclic.a $(LIBM)

noinst_PROGRAMS = mean
mean_CFLAGS = $(nothreads)
mean_LDADD = libacyclic.a libcountdown.a $(LIBM)

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

CLEANFILES = countdown-1-1

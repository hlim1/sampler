liblib_LIBRARIES = $(nothread_libs) $(thread_libs)

libinclude_HEADERS =				\
	acyclic.h				\
	countdown.h				\
	cyclic.h				\
	cyclic-size.h


########################################################################


acyclic_cflags = -DSAMPLER_ACYCLIC -ffast-math
cyclic_cflags = -DSAMPLER_CYCLIC

acyclic_sources = acyclic.c acyclic.h countdown.h lifetime.h
cyclic_sources = countdown.h cyclic.c cyclic.h cyclic-size.h

nothread_cflags = -include $(top_srcdir)/libthreads/no-threads.h
thread_cflags = -include $(top_srcdir)/libthreads/threads.h -pthread

nothread_sources = no-hijack.c
thread_sources = hijack.c


########################################################################


nothread_libs =					\
	libacyclic.a				\
	libcountdown.a				\
	libcyclic.a

libacyclic_a_SOURCES = $(acyclic_sources) $(nothread_sources)
libacyclic_a_CFLAGS = $(acyclic_cflags) $(nothread_cflags)
libcyclic_a_SOURCES = $(cyclic_sources) $(nothread_sources)
libcyclic_a_CFLAGS = $(cyclic_cflags) $(nothread_cflags)
libcountdown_a_SOURCES = countdown.c countdown.h
libcountdown_a_CFLAGS = $(nothread_cflags)


########################################################################


if HAVE_THREAD_STORAGE
thread_libs =					\
	libacyclic_r.a				\
	libcountdown_r.a			\
	libcyclic_r.a

libacyclic_r_a_SOURCES = $(acyclic_sources) $(thread_sources)
libacyclic_r_a_CFLAGS = $(acyclic_cflags) $(thread_cflags)
libcyclic_r_a_SOURCES = $(cyclic_sources) $(thread_sources)
libcyclic_r_a_CFLAGS = $(cyclic_cflags) $(thread_cflags)
libcountdown_r_a_SOURCES = countdown.c countdown.h
libcountdown_r_a_CFLAGS = $(thread_cflags)
endif


########################################################################


tools_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_CFLAGS = $(nothread_cflags)
precompute_LDADD = libacyclic.a $(LIBM)

noinst_PROGRAMS = mean
mean_CFLAGS = $(nothread_cflags)
mean_LDADD = libacyclic.a libcountdown.a $(LIBM)

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

CLEANFILES = countdown-1-1

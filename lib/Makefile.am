if HAVE_THREAD_STORAGE
thread_lib = libsampler_r.a
endif

liblib_LIBRARIES =				\
	libsampler.a				\
	$(thread_lib)


liblib_HEADERS =				\
	acyclic.h				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.h				\
	no-threads.h				\
	requires.h				\
	threads.h				\
	unit.h



INCLUDES = -W -Wall -Werror -ffast-math

common_sources =				\
	acyclic.c				\
	acyclic.h				\
	anchor.h				\
	countdown.c				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.c				\
	cyclic.h				\
	lifetime.h				\
	lock.h					\
	report.c				\
	report.h				\
	unit.c					\
	unit.h


########################################################################


libsampler_a_SOURCES =				\
	$(common_sources)			\
	no-hijack.c				\
	no-threads.h

libsampler_a_CFLAGS = -include $(srcdir)/no-threads.h


########################################################################


libsampler_r_a_SOURCES =			\
	$(common_sources)			\
	hijack.c				\
	lock.c					\
	threads.h

libsampler_r_a_CFLAGS = -include $(srcdir)/threads.h -pthread


########################################################################


tools_PROGRAMS = precompute
precompute_CFLAGS = -include $(srcdir)/no-threads.h
precompute_LDADD = libsampler.a $(LIBM)

noinst_PROGRAMS = mean
mean_CFLAGS = -include $(srcdir)/no-threads.h
mean_LDADD = libsampler.a $(LIBM)

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

CLEANFILES = countdown-1-1

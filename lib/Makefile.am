CFLAGS = -O9 -W -Wall -Werror

if HAVE_THREAD_STORAGE
thread_lib = libsampler_r.a
endif

lib_LIBRARIES =					\
	libsampler.a				\
	libschemes.a				\
	$(thread_lib)


package_include_HEADERS =			\
	acyclic.h				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.h				\
	no-threads.h				\
	threads.h				\
	unit-signature.h			\
	unit.h



INCLUDES = -ffast-math

common_sources =				\
	acyclic.c				\
	acyclic.h				\
	countdown.c				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.c				\
	cyclic.h				\
	lifetime.h				\
	lock.h					\
	registry.c				\
	registry.h				\
	report.c				\
	report.h


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
	threads.h

libsampler_r_a_CFLAGS = -include $(srcdir)/threads.h -pthread


########################################################################


libschemes_a_SOURCES =				\
	branches.c				\
	branches-types.h			\
	function-entries.c			\
	function-entries-types.h		\
	returns.c				\
	returns-types.h				\
	scalar-pairs.c				\
	scalar-pairs-types.h


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

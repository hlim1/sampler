AM_CFLAGS = -W -Wall -Werror

if HAVE_THREAD_STORAGE
thread_lib = libsampler_r.a
endif

lib_LIBRARIES =					\
	libsampler.a				\
	libschemes.a				\
	$(thread_lib)


package_include_HEADERS =			\
	acyclic.h				\
	bounds-types.h				\
	bounds-unit.h				\
	branches-types.h			\
	branches-unit.h				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.h				\
	function-entries-types.h		\
	function-entries-unit.h			\
	lifetime.h				\
	lock.h					\
	log.h					\
	no-threads.h				\
	registry.h				\
	report.h				\
	returns-types.h				\
	returns-unit.h				\
	returns.h				\
	scalar-pairs-types.h			\
	scalar-pairs-unit.h			\
	scalar-pairs.h				\
	signature.h				\
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
	report.h				\
	signature.h


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
	bounds.c				\
	bounds-types.h				\
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

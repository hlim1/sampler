AM_CFLAGS = -W -Wall -Werror -Wformat=2
INCLUDES = -ffast-math @GLIB_CFLAGS@

if HAVE_THREAD_STORAGE
thread_lib = libsampler_r.a
endif

lib_LIBRARIES =					\
	libdump.a				\
	libdump-timestamps.a			\
	libsampler.a				\
	libschemes.a				\
	$(thread_lib)


EXTRA_DIST = g-object-unref-unit.h

if WITH_GNOME
gnome_headers =					\
	g-object-unref.h			\
	g-object-unref-unit.h
endif

package_include_HEADERS =			\
	$(gnome_headers)			\
	acyclic.h				\
	bounds-unit.h				\
	branches-unit.h				\
	countdown.h				\
	cyclic-size.h				\
	cyclic.h				\
	function-entries-unit.h			\
	lifetime.h				\
	lock.h					\
	log.h					\
	registry.h				\
	report.h				\
	returns-unit.h				\
	scalar-pairs-unit.h			\
	signature.h				\
	threads.h				\
	tuple-1.h				\
	tuple-2.h				\
	tuple-3.h				\
	tuple-4.h				\
	unit-signature.h			\
	unit.h


########################################################################


sampler_sources =				\
	acyclic.c				\
	acyclic.h				\
	clock.c					\
	clock.h					\
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
	signature.h				\
	threads.h


libsampler_a_SOURCES =				\
	$(sampler_sources)			\
	no-hijack.c


libsampler_r_a_SOURCES =			\
	$(sampler_sources)			\
	hijack.c

libsampler_r_a_CFLAGS = -pthread -DSAMPLER_THREADS


########################################################################


dump_sources = dump.c

libdump_a_SOURCES = $(dump_sources)

libdump_timestamps_a_SOURCES = $(dump_sources)
libdump_timestamps_a_CFLAGS = -DSAMPLER_TIMESTAMPS


########################################################################


if WITH_GNOME
gnome_sources =					\
	g-object-unref.c			\
	g-object-unref-report.h			\
	g-object-unref-classify.h
endif

libschemes_a_SOURCES =				\
	$(gnome_sources)			\
	bounds.c				\
	bounds.h				\
	branches.c				\
	branches.h				\
	function-entries.c			\
	function-entries.h			\
	returns.c				\
	returns.h				\
	scalar-pairs.c				\
	scalar-pairs.h


########################################################################


tools_PROGRAMS = precompute
precompute_LDADD = libsampler.a $(LIBM)

noinst_PROGRAMS = mean
mean_LDADD = libsampler.a $(LIBM)

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

CLEANFILES = countdown-1-1

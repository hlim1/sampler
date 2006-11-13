AM_CFLAGS = -W -Wall -Werror -Wformat=2
INCLUDES = -ffast-math @GLIB_CFLAGS@

if HAVE_THREAD_STORAGE
thread_lib = libsampler-threads.a
endif

lib_LIBRARIES =					\
	libsampler.a				\
	libsampler-no-threads.a			\
	$(thread_lib)


EXTRA_DIST = g-object-unref-unit.h

if WITH_GNOME
gnome_headers =					\
	g-object-unref.h			\
	g-object-unref-unit.h
endif

package_include_HEADERS =			\
	$(gnome_headers)			\
	bounds.h				\
	bounds-unit.h				\
	branches.h				\
	branches-unit.h				\
	countdown.h				\
	function-entries.h			\
	function-entries-unit.h			\
	lifetime.h				\
	lock.h					\
	log.h					\
	random-fixed.h				\
	random-online.h				\
	random-offline.h			\
	random-offline-size.h			\
	registry.h				\
	report.h				\
	returns.h				\
	returns-unit.h				\
	scalar-pairs.h				\
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


thread_sources =				\
	countdown.c				\
	countdown.h				\
	lifetime.h				\
	lock.h					\
	once.h					\
	random-fixed.c				\
	random-fixed.h				\
	random-online.c				\
	random-online.h				\
	random-offline.c			\
	random-offline.h			\
	random-offline-size.h			\
	registry.c				\
	registry.h				\
	report.c				\
	report.h				\
	signature.h				\
	timestamps-set.c			\
	threads.h

libsampler_no_threads_a_SOURCES =		\
	$(thread_sources)			\
	once-no-threads.h			\
	no-hijack.c

libsampler_threads_a_SOURCES =			\
	$(thread_sources)			\
	once-threads.h				\
	hijack.c

libsampler_threads_a_CFLAGS = -pthread -DSAMPLER_THREADS


########################################################################


if WITH_GNOME
gnome_sources =					\
	g-object-unref.c			\
	g-object-unref-classify.c
endif

libsampler_a_SOURCES =				\
	$(gnome_sources)			\
	bounds.c				\
	bounds.h				\
	branches.c				\
	branches.h				\
	function-entries.c			\
	function-entries.h			\
	returns.c				\
	returns.h				\
	samples.c				\
	samples.h				\
	scalar-pairs.c				\
	scalar-pairs.h				\
	timestamps.c				\
	timestamps.h				\
	tuple-1.c				\
	tuple-1.h				\
	tuple-2.c				\
	tuple-2.h				\
	tuple-3.c				\
	tuple-3.h				\
	tuple-4.c				\
	tuple-4.h


########################################################################


tools_PROGRAMS = precompute
precompute_LDADD = libsampler.a libsampler-no-threads.a $(LIBM)

noinst_PROGRAMS = mean
mean_LDADD = libsampler.a libsampler-no-threads.a $(LIBM)

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@


########################################################################


CLEANFILES = countdown-1-1

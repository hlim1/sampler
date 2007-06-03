AM_CFLAGS = -ffast-math -fpic
AM_LDFLAGS = -Wl,--unresolved-symbols=ignore-in-shared-libs

include ../threads.mk

threads_no_HEADERS = $(headers)

lib_LTLIBRARIES =				\
	libsampler-fixed.la			\
	libsampler-offline.la			\
	libsampler-online.la

libsampler_fixed_la_SOURCES = ../random-fixed.c $(common)
libsampler_offline_la_SOURCES = ../random-offline.c $(common)
libsampler_online_la_SOURCES = ../random-online.c $(common)


########################################################################


tools_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_LDADD = libsampler-online.la $(LIBM)

force:
.PHONY: force

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@


########################################################################


CLEANFILES = countdown-1-1

AM_CFLAGS = -ffast-math -fpic

include ../threads.mk

threads_no_LIBRARIES = $(libraries)
threads_no_HEADERS = $(headers)


########################################################################


tools_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_LDADD = librandom-online.a liblate.a $(LIBM)

force:
.PHONY: force

countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@


########################################################################


CLEANFILES = countdown-1-1

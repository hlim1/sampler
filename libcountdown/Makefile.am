INCLUDES = -W -Wall -Werror `gsl-config --cflags`


lib_LTLIBRARIES = libacyclic.la libcyclic.la

libacyclic_la_SOURCES = countdown.h acyclic.h acyclic.c
libcyclic_la_SOURCES = countdown.h cyclic.h cyclic.c

libexec_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_LDADD = libacyclic.la
precompute_LDFLAGS = `gsl-config --libs`

noinst_PROGRAMS = mean
mean_LDFLAGS = `gsl-config --libs`


countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

clean:
	rm -f countdown-1-1

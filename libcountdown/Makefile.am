INCLUDES = -W -Wall -Werror `gsl-config --cflags`


lib_LTLIBRARIES = libacyclic.la libcyclic.la libevent.la libfunc.la

libacyclic_la_SOURCES = acyclic.c acyclic.h
libcyclic_la_SOURCES = cyclic.c cyclic.h cyclic-internals.h cyclic-size.h
libevent_la_SOURCES = event.c event.h
libfunc_la_SOURCES = func.c func.h

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

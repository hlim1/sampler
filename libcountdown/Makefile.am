INCLUDES = -W -Wall -Werror `gsl-config --cflags`

lib_LTLIBRARIES = libacyclic.la libcountdown.la libcyclic.la

libacyclic_la_SOURCES = acyclic.c acyclic.h countdown.h
libacyclic_la_LIBADD = libcountdown.la
libacyclic_la_LDFLAGS = `gsl-config --libs`

libcyclic_la_SOURCES = countdown.h cyclic.c cyclic.h cyclic-size.h
libcyclic_la_LIBADD = libcountdown.la

libcountdown_la_SOURCES = countdown.c countdown.h

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

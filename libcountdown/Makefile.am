INCLUDES = -W -Wall -Werror `gsl-config --cflags`

lib_LIBRARIES = libacyclic.a libcountdown.a libcyclic.a

libacyclic_a_SOURCES = acyclic.c acyclic.h countdown.h
libacyclic_a_LIBADD = libcountdown.a

libcyclic_a_SOURCES = countdown.h cyclic.c cyclic.h cyclic-size.h
libcyclic_a_LIBADD = libcountdown.a

libcountdown_a_SOURCES = countdown.c countdown.h

libexec_PROGRAMS = precompute
precompute_SOURCES = precompute.c
precompute_LDADD = libacyclic.a
precompute_LDFLAGS = `gsl-config --libs`

noinst_PROGRAMS = mean
mean_LDFLAGS = `gsl-config --libs`


countdown-1-1: precompute
	SAMPLER_SPARSITY=1 ./precompute $@

clean:
	rm -f countdown-1-1

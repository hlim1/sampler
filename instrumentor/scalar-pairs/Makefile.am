SUBDIRS = tests

scheme = scalar-pairs
scheme_SCRIPTS = main
scheme_DATA = Driver.pm
scheme_LIBRARIES = libscalar-pairs.a
scheme_HEADERS = scalar-pairs.h

libscalar_pairs_a_SOURCES = scalar-pairs.c scalar-pairs.h

EXTRA_DIST = $(scheme_DATA)

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

dumpConstants: $(libcil) $(dumpConstants)
	$(link)

const: const.c main
	../driver/main scalar-pairs --compare-constants -save-temps -W -Wall $<

SUBDIRS = libscalar-pairs tests

scheme = scalar-pairs
scheme_SCRIPTS = main
scheme_DATA = Driver.pm
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

SUBDIRS = libscalar-pairs tests
targets = main

EXTRA_DIST = Driver.pm

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

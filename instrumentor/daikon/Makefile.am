targets = main

scheme = daikon
noinst_SCRIPTS = main
noinst_DATA = specs
noinst_LIBRARIES = libdaikon.a
noinst_HEADERS = daikon.h

libdaikon_a_SOURCES = daikon.c daikon.h

EXTRA_DIST = $(noinst_DATA)

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

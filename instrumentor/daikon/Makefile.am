SUBDIRS = libdaikon
targets = main

scheme = daikon
noinst_SCRIPTS = main
noinst_DATA = Driver.pm
EXTRA_DIST = $(noinst_DATA)

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

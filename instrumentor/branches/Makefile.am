SUBDIRS = libbranches tests
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

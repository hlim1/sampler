SUBDIRS = libreturns tests

scheme = returns
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

SUBDIRS = tests

scheme = returns
scheme_SCRIPTS = main
scheme_DATA = Driver.pm
scheme_LIBRARIES = libreturns.a
scheme_HEADERS = returns.h

libreturns_a_SOURCES = returns.c returns.h

EXTRA_DIST = $(scheme_DATA)

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

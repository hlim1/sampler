SUBDIRS = tests

scheme = branches
scheme_SCRIPTS = main
scheme_DATA = specs
scheme_LIBRARIES = libbranches.a
scheme_HEADERS = branches.h

libbranches_a_SOURCES = branches.c branches.h

EXTRA_DIST = $(scheme_DATA)

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.$(cma): $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

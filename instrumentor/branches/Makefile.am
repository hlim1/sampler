SUBDIRS = tests

scheme = branches
scheme_SCRIPTS = main
scheme_DATA = specs
scheme_LIBRARIES = libbranches.a
scheme_HEADERS = branches.h

libbranches_a_SOURCES = branches.c branches.h

EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += main


libcil = $(cil_libdir)/cil.$(cma)
libharness = ../harness.$(cma)
libdirs += ..
syslibs = str.$(cma) unix.$(cma)

../%.cmi: $(libharness)

%.$(cma): $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

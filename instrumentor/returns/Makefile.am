SUBDIRS = tests

scheme = returns
scheme_SCRIPTS = main
scheme_DATA = specs
scheme_LIBRARIES = libreturns.a
scheme_HEADERS = returns.h

libreturns_a_SOURCES = returns.c returns.h

EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += main


libcil = $(cil_libdir)/cil.$(cma)
libharness = ../harness.$(cma)
libdirs += ..
syslibs = str.$(cma) unix.$(cma)

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

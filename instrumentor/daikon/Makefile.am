targets = main

scheme = daikon
noinst_SCRIPTS = main
noinst_DATA = specs
noinst_LIBRARIES = libdaikon.a
noinst_HEADERS = daikon.h

libdaikon_a_SOURCES = daikon.c daikon.h

EXTRA_DIST = $(noinst_DATA)

include $(top_srcdir)/ocaml/rules.mk


libcil = $(cil_libdir)/cil.$(cma)
libharness = ../harness.$(cma)
libdirs += ..
syslibs = str.$(cma) unix.$(cma)

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

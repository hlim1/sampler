SUBDIRS = tests

scheme = scalar-pairs
scheme_SCRIPTS = main
scheme_DATA = specs
scheme_LIBRARIES = libscalar-pairs.a
scheme_HEADERS = scalar-pairs.h

libscalar_pairs_a_SOURCES = scalar-pairs.c scalar-pairs.h

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

dumpConstants: $(libcil) $(dumpConstants)
	$(link)

const: const.c main
	../driver/main scalar-pairs --compare-constants -save-temps -W -Wall $<

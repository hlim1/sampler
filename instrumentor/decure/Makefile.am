SUBDIRS = tests

scheme = decure
noinst_SCRIPTS = main
noinst_DATA = specs
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

filterComplete: $(libcil) $(libharness) $(filterComplete)
	$(link)

listCandidates: $(libcil) $(libharness) $(listCandidates)
	$(link)

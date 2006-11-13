targets = main

scheme = daikon
noinst_SCRIPTS = main
noinst_DATA = specs
noinst_LIBRARIES = libdaikon.a
noinst_HEADERS = daikon.h

libdaikon_a_SOURCES = daikon.c daikon.h

EXTRA_DIST = $(noinst_DATA)

include $(top_srcdir)/ocaml/rules.mk


libdirs += ..
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness); @:
$(dir $(libcommon))/%.cmi: $(libcommon); @:

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libcommon) $(libharness) $(main)
	$(link)

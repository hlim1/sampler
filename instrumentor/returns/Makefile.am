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


libdirs += ..
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness)
$(dir $(libcommon))/%.cmi: $(libcommon)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libcommon) $(libharness) $(main)
	$(link)

SUBDIRS = tests

scheme = nothing
scheme_SCRIPTS = main
scheme_DATA = specs
EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += main


libdirs += ..
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness); :
$(dir $(libcommon))/%.cmi: $(libcommon); :

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libcommon) $(libharness) $(main)
	$(link)

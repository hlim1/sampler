SUBDIRS = tests

scheme = decure
noinst_SCRIPTS = main
noinst_DATA = specs
EXTRA_DIST = $(noinst_DATA)

include $(top_srcdir)/ocaml/rules.mk


libdirs += ..
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness)
$(dir $(libcommon))/%.cmi: $(libcommon)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libcommon) $(libharness) $(main)
	$(link)

filterComplete: $(libcil) $(libharness) $(filterComplete)
	$(link)

listCandidates: $(libcil) $(libharness) $(listCandidates)
	$(link)

SUBDIRS = tests

scheme = branches
scheme_DATA = specs
scheme_LIBRARIES = libbranches.a
scheme_HEADERS = branches.h

libbranches_a_SOURCES = branches.c branches.h

EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += $(scheme).$(cma)


libdirs += .. $(top_builddir)/ocaml
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness); :
$(dir $(libcommon))/%.cmi: $(libcommon); :

%.$(cma): $(force)
	$(recurse)


$(scheme).$(cma): $($(scheme)Scheme)
	$(archive)

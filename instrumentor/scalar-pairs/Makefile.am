SUBDIRS = tests

scheme = scalar-pairs
scheme_DATA = specs
scheme_LIBRARIES = libscalar-pairs.a
scheme_HEADERS = scalar-pairs.h

libscalar_pairs_a_SOURCES = scalar-pairs.c scalar-pairs.h

EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += $(scheme).$(cma)

libdirs += $(dir $(libharness)) $(dir $(libcommon))
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))%.cmi: $(libharness); @:
$(dir $(libcommon))%.cmi: $(libcommon); @:

$(libharness): $(force); $(recurse)
$(libcommon): $(force); $(recurse)

all-local: $(scheme).$(cma)
$(scheme).$(cma): $(scalarPairScheme); $(archive)

dumpConstants: $(libcil) $(dumpConstants)
	$(link)

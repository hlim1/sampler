SUBDIRS = tests

scheme = nothing
scheme_DATA = specs
EXTRA_DIST = $(scheme_DATA)

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += main

libdirs += $(dir $(libharness))
syslibs = str.$(cma) unix.$(cma)

$(dir $(libharness))/%.cmi: $(libharness); @:

$(libharness): $(force); $(recurse)

all-local: $(scheme).$(cma)
$(scheme).$(cma): $(nothingScheme); $(archive)

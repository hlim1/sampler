SUBDIRS = tests

scheme = returns
scheme_DATA = specs
scheme_LIBRARIES = libreturns.a
scheme_HEADERS = returns.h

libreturns_a_SOURCES = returns.c returns.h

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
$(scheme).$(cma): $(returnScheme); $(archive)

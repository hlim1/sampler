EXTRA_DIST =

include $(top_srcdir)/ocaml/rules.mk

libdirs += $(dir $(libcommon))

all-local: user graphlib.$(cma)

user: $(libcommon) $(user)
	$(link)

graphlib = $(graph) $(transitive)

graphlib.$(cma): $(graphlib)
	$(archive)

$(dir $(libcommon))%.cmi: $(libcommon)

$(libcommon): $(force)
	$(recurse)

ocamlflags = -warn-error A

include $(top_builddir)/ocaml/config.mk

linkorder = $(top_srcdir)/ocaml/link-order

libdirs = $(cil_libdir)
includes = $(foreach dir, $(libdirs), -I $(dir))
compiler = $(ocamlc) $(ocamlflags)

depend = ocamldep $(includes) $< >$@
compile = $(compiler) $(includes) -c $<
archive = $(compiler) -a -o $@ $^
link = $(compiler) $(includes) -o $@ $(syslibs) $^

force ?= force
recurse = $(MAKE) -C $(@D) $(@F) force=


########################################################################


libcil = $(cil_libdir)/cil.$(cma)
libcommon = $(top_builddir)/ocaml/common.$(cma)
libharness = $(error harness library is no longer used)


########################################################################


ml = $(notdir $(wildcard $(srcdir)/*.ml))
mli = $(notdir $(wildcard $(srcdir)/*.mli))
EXTRA_DIST += $(sort $(ml) $(mli))

impls = $(sort $(extra_impls) $(ml:.ml=))
ifaces = $(mli:.mli=)
implicits = $(filter-out $(ifaces), $(impls))


########################################################################


$(addsuffix .cmi, $(ifaces)): %.cmi: %.mli
	$(compile)

$(addsuffix .cmi, $(implicits)): %.cmi: %.ml
	$(compile)

$(addsuffix .$(cmo), $(impls)): %.$(cmo): %.ml
	$(compile)

$(addsuffix .di, $(ifaces)): %.di: %.mli
	$(depend)

$(addsuffix .do, $(impls)): %.do: %.ml
	$(depend)

$(addsuffix .dl, $(impls)): %.dl: %.do $(linkorder)
	$(linkorder) <$< >$@

browse: force
	ocamlbrowser $(includes)
.PHONY: browse

force:
.PHONY: force


MOSTLYCLEANFILES = $(targets) *.annot *.cma *.cmxa *.cmi *.cmo *.cmx *.o
CLEANFILES = *.d[ilo]

.DELETE_ON_ERROR:


########################################################################


-include $(ifaces:=.di)
-include $(impls:=.do)
-include $(impls:=.dl)

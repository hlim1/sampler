include $(top_builddir)/ocaml/config.mk


linkorder = $(top_srcdir)/ocaml/link-order

libdirs = $(cil_libdir)
includes = $(foreach dir, $(libdirs), -I $(dir))
compiler = $(ocamlc) $(ocamlflags)

depend = ocamldep $(includes) $< >$@.tmp
compile = $(compiler) $(includes) -c $<
archive = $(compiler) -a -o $@ $^
link = $(compiler) -o $@ $(syslibs) $^

force ?= force
recurse = $(MAKE) -C $(@D) $(@F) force=


########################################################################


ml = $(wildcard *.ml)
mli = $(wildcard *.mli)
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
	mv $@.tmp $@

$(addsuffix .do, $(impls)): %.do: %.ml
	$(depend)
	mv $@.tmp $@

$(addsuffix .dl, $(impls)): %.dl: %.do $(linkorder)
	$(linkorder) <$< >$@.tmp
	mv $@.tmp $@

browse: force
	ocamlbrowser $(includes)
.PHONY: browse

force:
.PHONY: force


MOSTLYCLEANFILES = $(targets) *.annot *.cma *.cmxa *.cmi *.cmo *.cmx *.o
CLEANFILES = *.d[ilo]


########################################################################


-include $(ifaces:=.di)
-include $(impls:=.do)
-include $(impls:=.dl)

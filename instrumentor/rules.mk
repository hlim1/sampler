include $(top_builddir)/instrumentor/config.mk
include $(top_builddir)/instrumentor/defs.mk


fixdeps = $(top_srcdir)/instrumentor/fixdeps

cildir = $(top_srcdir)/../cil
cilobjdir = $(cildir)/obj/x86_LINUX
libdirs = $(cilobjdir)
includes = $(foreach dir, $(libdirs), -I $(dir))
compiler = $(ocamlc) $(ocamlflags)

depend = ocamldep $(includes) $< | $(fixdeps) >$@
compile = $(compiler) $(includes) -c $<
archive = $(compiler) -a -o $@ $^
link = $(compiler) -o $@ $(syslibs) $^

force = force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


libcil = $(cilobjdir)/cil.$(cma)
syslibs = str.$(cma) unix.$(cma)

impls = $(basename $(wildcard $(srcdir)/*.ml))
ifaces = $(basename $(wildcard $(srcdir)/*.mli))
implicits = $(filter-out $(ifaces), $(impls))


########################################################################


all-local: $(targets)

$(addsuffix .$(cmo), $(impls)): %.$(cmo): %.ml
	$(compile)

$(addsuffix .cmi, $(ifaces)): %.cmi: %.mli
	$(compile)

$(addsuffix .cmi, $(implicits)): %.cmi: %.ml
	$(compile)

$(addsuffix .do, $(impls)): %.do: %.ml $(fixdeps)
	$(depend)

$(addsuffix .di, $(ifaces)): %.di: %.mli $(fixdeps)
	$(depend)

$(libcil): $(force)
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVECAML=$(native) cillib

force:
.PHONY: force


browse: force
	ocamlbrowser $(includes)
.PHONY: browse


MOSTLYCLEANFILES = $(targets) *.cma *.cmxa *.cmi *.cmo *.cmx *.o
CLEANFILES = *.di *.do


########################################################################


-include $(impls:=.do)
-include $(ifaces:=.di)

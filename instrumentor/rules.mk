include $(top_builddir)/instrumentor/config.mk


fixdeps = $(top_srcdir)/instrumentor/fixdeps

cildir = $(CIL_HOME)
cilobjdir = $(cildir)/obj/x86_LINUX
libdirs = $(cilobjdir)
includes = $(foreach dir, $(libdirs), -I $(dir))
compiler = $(ocamlc) $(ocamlflags)

depend = ocamldep $(includes) $<
compile = $(compiler) $(includes) -c $<
archive = $(compiler) -a -o $@ $^
link = $(compiler) -o $@ $(syslibs) $^

force = force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


libcil = $(cilobjdir)/cil.$(cma)
syslibs = str.$(cma) unix.$(cma)

ml = $(wildcard *.ml)
mli = $(wildcard *.mli)
EXTRA_DIST += $(sort $(ml) $(mli))

impls = $(sort $(extra_impls) $(ml:.ml=))
ifaces = $(mli:.mli=)
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
	$(depend) | $(fixdeps) >$@

$(addsuffix .di, $(ifaces)): %.di: %.mli $(fixdeps)
	$(depend) >$@

$(libcil): $(force)
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVECAML=$(ENABLE_NATIVE) cillib

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

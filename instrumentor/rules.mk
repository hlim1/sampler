fixdeps := $(top)/fixdeps

cildir := $(top)/../../cil
cilobjdir := $(cildir)/obj/x86_LINUX
libdirs += $(cilobjdir)
includes := $(foreach dir, $(libdirs), -I $(dir))
compiler := $(ocamlc) $(ocamlflags)

depend = ocamldep $(includes) $< | $(fixdeps) >$@
compile = $(compiler) $(includes) -c $<
archive = $(compiler) -a -o $@ $(libs) $^
link = $(compiler) -o $@ $(libs) $^

recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


libcil := $(cilobjdir)/cil.$(cma)

impls := $(basename $(wildcard *.ml))
ifaces := $(basename $(wildcard *.mli))
implicits := $(filter-out $(ifaces), $(impls))


########################################################################


all: $(targets) $(addsuffix /all, $(subdirs))
.PHONY: all

%/all: force
	$(recurse)
.PHONY: all

parts: $(impls:=.$(cmo)) $(ifaces:=.cmi)
.PHONY: parts

$(impls:=.$(cmo)): %.$(cmo): %.ml
	$(compile)

$(ifaces:=.cmi): %.cmi: %.mli
	$(compile)

$(implicits:=.cmi): %.cmi: %.ml
	$(compile)

$(impls:=.do): %.do: %.ml $(fixdeps)
	$(depend)

$(ifaces:=.di): %.di: %.mli $(fixdeps)
	$(depend)

$(libcil): force
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVECAML=$(native) cillib

force:
.PHONY: force


clean-here:: force
	rm -f $(targets)
	rm -f $(foreach suffix, cmi cmo cmx o, *.$(suffix))
.PHONY: clean-here

clean:: force clean-here $(addsuffix /clean, $(subdirs))
.PHONY: clean

%/clean: force
	$(recurse)
.PHONY: %/clean


spotless: force clean-here $(addsuffix /spotless, $(subdirs))
	rm -f *.d *.di *.do
.PHONY: spotless

%/spotless: force
	$(recurse)
.PHONY: %/spotless


check:: force $(addsuffix /check, $(subdirs))
.PHONY: check

%/check: force
	$(recurse)
.PHONY: %/check


browse: force
	ocamlbrowser $(includes)
.PHONY: browse


########################################################################


ifdef impls
-include $(impls:=.do)
endif

ifdef ifaces
-include $(ifaces:=.di)
endif

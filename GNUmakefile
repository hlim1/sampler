ifdef native
ocamlc := ocamlopt.opt
cma := cmxa
cmo := cmx
else
ocamlflags := -g
ocamlc := ocamlc.opt
cma := cma
cmo := cmo
endif

fixdeps := ./fixdeps

cildir := ../cil
cilobjdir := $(cildir)/obj/x86_LINUX
includes := -I $(cilobjdir)
compiler := $(ocamlc) $(ocamlflags)

compile = $(compiler) $(includes) -c $<
link = $(compiler) -o $@ $(syslibs) $^


########################################################################


libcil := $(cilobjdir)/cil.$(cma)
libs := $(libcil)
syslibs := unix.$(cma)

infile := hello

targets := cfg-to-dot main
impls := $(basename $(wildcard *.ml))
ifaces := $(basename $(wildcard *.mli))

all: $(targets)
.PHONY: all

parts: $(impls:=.$(cmo)) $(ifaces:=.cmi)
.PHONY: parts

run: main $(infile).i
	./$^
.PHONY: run

dumper: %: $(libs) $(addsuffix .$(cmo), skipVisitor cfg functionBodyVisitor testHarness utils %)
	$(link)

cfg-to-dot: %: $(libs) $(addsuffix .$(cmo), cfg utils foreach dotify skipVisitor functionBodyVisitor splitAfterCalls testHarness %)
	$(link)

main: %: $(libs) $(addsuffix .$(cmo), skipVisitor functionBodyVisitor currentFunctionVisitor simplifyReturns simplifyLefts simplifyRights checkSimplicity instrument testHarness %)
	$(link)

checker: %: $(libs) $(addsuffix .$(cmo), %)
	$(link)

$(ifaces:=.cmi): %.cmi: %.mli
	$(compile)

$(impls:=.$(cmo)): %.$(cmo): %.ml
	$(compile)

$(impls:=.do): %.do: %.ml $(fixdeps)
	ocamldep $(includes) $< | $(fixdeps) >$@

$(ifaces:=.di): %.di: %.mli $(fixdeps)
	ocamldep $(includes) $< | $(fixdeps) >$@

$(libcil): $(force)
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVE=$(native) cillib

force:
.PHONY: force

%.i: %.c
	$(CC) $(CPPFLAGS) $< -o $@ -E

%.d: %.c
	$(CC) $(CPPFLAGS) $< -o $*.i -M >$@

%.cfg.dot: cfg-to-dot %.i
	./$^ >$@

%.dom.dot: dom-to-dot %.i
	./$^ >$@

%.ps: %.dot
	dot -Tps -Gsize=7.5,10 -Gcenter=1 -o $@ $<

clean: force
	rm -f $(targets) hello.i
	rm -f $(foreach suffix, cmi cmo cmx o, *.$(suffix))
	rm -f $(foreach kind, cfg dom, $(foreach format, dot ps, *.$(kind).$(format)))
.PHONY: clean

spotless: clean force
	rm -f *.d *.di *.do
.PHONY: spotless

-include $(impls:=.do)
-include $(ifaces:=.di)
-include $(infile).d

fixdeps := ./fixdeps

cildir := ../cil
cilobjdir := $(cildir)/obj/x86_LINUX
ocamlflags := -g
includes := -I $(cilobjdir)
ocamlc := ocamlc.opt
compiler := $(ocamlc) $(ocamlflags)

compile = $(compiler) $(includes) -c $<
link = $(compiler) -o $@ $(syslibs) $^


########################################################################


libcil := $(cilobjdir)/cil.cma
libs := $(libcil)
syslibs := unix.cma

infile := hello

targets := sampler cfg-to-dot dom-to-dot findLoopsAST findLoopsCFG findBackEdges weighPaths
parts := $(basename $(wildcard *.ml))

all: $(targets)
.PHONY: all

parts: $(parts:=.cmo)
.PHONY: parts

run: weighPaths $(infile).i
	./$<
.PHONY: run

sampler: %: $(libs) $(addsuffix .cmo, utils testHarness %)
	$(link)

cfg-to-dot: %: $(libs) $(addsuffix .cmo, utils dotify testHarness %)
	$(link)

dom-to-dot: %: $(libs) $(addsuffix .cmo, foreach mapClass setClass utils dominators dotify testHarness %)
	$(link)

findBackEdges: %: $(libs) $(addsuffix .cmo, setClass utils foreach testHarness %)
	$(link)

weighPaths: %: $(libs) $(addsuffix .cmo, mapClass setClass utils foreach testHarness %)
	$(link)

findLoopsAST: %: $(libs) $(addsuffix .cmo, utils testHarness %)
	$(link)

findLoopsCFG: %: $(libs) $(addsuffix .cmo, utils mapClass setClass stackClass foreach dominators testHarness %)
	$(link)

$(parts:=.cmi): %.cmi: %.mli
	$(compile)

$(parts:=.cmo): %.cmo: %.ml
	$(compile)

$(parts:=.d): %.d: %.ml $(fixdeps)
	ocamldep $(includes) $< | $(fixdeps) >$@

$(libcil): $(force)
	$(MAKE) -C $(cildir) -f Makefile.cil cillib

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
	rm -f $(targets) $(infile).i
	rm -f $(foreach suffix, cmi cmo cmx, *.$(suffix))
	rm -f $(foreach kind, cfg dom, $(foreach format, dot ps, *.$(kind).$(format)))
.PHONY: clean

spotless: clean force
	rm -f *.d
.PHONY: spotless

-include $(parts:=.d)
-include $(infile).d

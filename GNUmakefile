#profile := 1
#native := 1

ifdef profile
native := 1
ocamlflags := -p
endif

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

depend = ocamldep $< | $(fixdeps) >$@
compile = $(compiler) $(includes) -c $<
link = $(compiler) -o $@ $(syslibs) $^

force := force


########################################################################


libcil := $(cilobjdir)/cil.$(cma)
libs := $(libcil)
syslibs := unix.$(cma)

infile := hello

targets := cfg-to-dot main
impls := $(basename $(wildcard *.ml))
ifaces := $(basename $(wildcard *.mli))
implicits := $(filter-out $(ifaces), $(impls))


########################################################################


afterCalls = $(functionBodyVisitor) $(logIsImminent) afterCalls
backwardJumps = $(logIsImminent) backwardJumps
bitFields = bitFields
cfg = cfg
cfgToDot = $(dotify) cfgToDot
checkSimplicity = $(bitFields) $(functionBodyVisitor) checkSimplicity
classifyJumps = $(functionBodyVisitor) $(stmtSet) classifyJumps
countdown = countdown
dotify = $(utils) dotify
duplicate = $(functionBodyVisitor) $(identity) $(stmtMap) duplicate
filterLabels = $(functionBodyVisitor) $(stmtSet) filterLabels
forwardJumps = forwardJumps
functionBodyVisitor = $(skipVisitor) functionBodyVisitor
functionEntry = $(logIsImminent) functionEntry
identity = identity
identity = identity
instrument = $(functionBodyVisitor) $(logWrite) instrument
logIsImminent = logIsImminent
logWrite = logWrite
mapClass = mapClass
patchSites = patchSites
removeLoops = $(functionBodyVisitor) removeLoops
setClass = setClass
simplify = $(simplifyLefts) $(simplifyReturns) $(simplifyRights) $(checkSimplicity) simplify
simplifyLefts = $(bitFields) $(simplifyVisitor) simplifyLefts
simplifyReturns = $(simplifyVisitor) simplifyReturns
simplifyRights = $(simplifyVisitor) simplifyRights
simplifyVisitor = $(functionBodyVisitor) simplifyVisitor
skipVisitor = skipVisitor
skipWrites = $(countDown) $(functionBodyVisitor) skipWrites
stmtMap = $(mapClass) stmtMap
stmtSet = $(setClass) stmtSet
stores = stores
testHarness = testHarness
transform = $(afterCalls) $(backwardJumps) $(classifyJumps) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(instrument) $(patchSites) $(removeLoops) $(simplify) $(skipWrites) $(weighPaths) transform
utils = utils
weighPaths = $(stmtMap) $(stores) weighPaths


########################################################################


all: $(targets)
.PHONY: all

parts: $(impls:=.$(cmo)) $(ifaces:=.cmi)
.PHONY: parts

run: main $(infile).i
	./$^
.PHONY: run

cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libs) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

main := $(countdown) $(filterLabels) $(logWrite) $(transform) $(testHarness) %
main: %: $(libs) $(addsuffix .$(cmo), $(main))
	$(link)

checker: %: $(libs) $(addsuffix .$(cmo), %)
	$(link)

dump: %: $(libs) $(addsuffix .$(cmo), %)
	$(link)

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

$(libcil): $(force)
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVECAML=$(native) cillib

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

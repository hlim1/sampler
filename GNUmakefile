top := .
include defs.mk

targets := cfg-to-dot harness.$(cma)
transformers := assignments heapStores loads
subdirs := libcountdown $(transformers)

include rules.mk


########################################################################


infile := hello


########################################################################


backwardJumps = $(clonesMap) backwardJumps
calls = $(clonesMap) $(functionBodyVisitor) calls
cfg = cfg
cfgToDot = $(dotify) cfgToDot
choices = choices
classifyJumps = $(functionBodyVisitor) $(stmtSet) classifyJumps
clonesMap = clonesMap
countdown = $(choices) $(findGlobal) countdown
dotify = $(utils) dotify
duplicate = $(functionBodyVisitor) $(identity) $(stmtMap) duplicate
filterLabels = $(functionBodyVisitor) $(stmtSet) filterLabels
findFunction = $(findGlobal) findFunction
findGlobal = findGlobal
forwardJumps = $(clonesMap) forwardJumps
functionBodyVisitor = $(skipVisitor) functionBodyVisitor
functionEntry = functionEntry
identity = identity
insertSkipsAfter = $(insertSkipsVisitor) insertSkipsAfter
insertSkipsBefore = $(insertSkipsVisitor) insertSkipsBefore
insertSkipsVisitor = $(functionBodyVisitor) insertSkipsVisitor
isolateInstructions = $(functionBodyVisitor) isolateInstructions
mapClass = mapClass
patchSites = patchSites
phases = $(filterLabels) $(testHarness) phases
printer = $(choices) $(filterLabels) printer
removeLoops = $(functionBodyVisitor) removeLoops
setClass = setClass
skipVisitor = skipVisitor
stmtMap = $(mapClass) stmtMap
stmtSet = $(setClass) stmtSet
testHarness = testHarness
transformVisitor = $(backwardJumps) $(calls) $(classifyJumps) $(countdown) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(insertSkipsVisitor) $(isolateInstructions) $(removeLoops) $(weighPaths) transformVisitor
utils = utils
weighPaths = $(stmtMap) weighPaths


########################################################################


cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libcil) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

harness := $(findFunction) $(insertSkipsAfter) $(insertSkipsBefore) $(phases) $(transformVisitor)
harness.$(cma): $(addsuffix .$(cmo), $(harness))
	$(archive)

checker: %: $(libcil) $(addsuffix .$(cmo), %)
	$(link)

dump: %: $(libcil) $(addsuffix .$(cmo), %)
	$(link)

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


########################################################################


-include $(infile).d

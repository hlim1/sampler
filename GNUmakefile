top := .
include defs.mk

targets := cfg-to-dot harness.$(cma)
libraries := libcountdown liblog
transformers := assignments heapStores loads localVars
subdirs := $(libraries) $(transformers)

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
dissect = $(outputSet) dissect
dotify = $(utils) dotify
duplicate = $(functionBodyVisitor) $(identity) $(stmtMap) duplicate
filterLabels = $(functionBodyVisitor) $(stmtSet) filterLabels
findFunction = $(findGlobal) findFunction
findGlobal = findGlobal
forwardJumps = $(clonesMap) forwardJumps
functionBodyVisitor = $(skipVisitor) functionBodyVisitor
functionEntry = functionEntry
identity = identity
isolateInstructions = $(functionBodyVisitor) isolateInstructions
logger = $(findFunction) $(outputSet) logger
mapClass = mapClass
outputSet = outputSet
patchSites = patchSites
phases = $(filterLabels) $(printer) $(testHarness) phases
printer = $(choices) printer
removeLoops = $(functionBodyVisitor) removeLoops
setClass = $(mapClass) setClass
sites = sites
skipVisitor = skipVisitor
stmtMap = $(mapClass) stmtMap
stmtSet = $(setClass) stmtSet
testHarness = testHarness
transformVisitor = $(backwardJumps) $(calls) $(classifyJumps) $(countdown) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(isolateInstructions) $(removeLoops) $(sites) $(weighPaths) transformVisitor
utils = utils
weighPaths = $(stmtMap) weighPaths


########################################################################


cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libcil) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

harness := $(dissect) $(findFunction) $(logger) $(phases) $(transformVisitor)
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

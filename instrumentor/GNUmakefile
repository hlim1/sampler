top := .
include defs.mk

targets := cfg-to-dot checker dump harness.$(cma)
subdirs := decure logging

include rules.mk


########################################################################


infile := hello


########################################################################


hashClass = hashClass
varHash = $(hashClass) varHash

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
isolateInstructions = $(functionBodyVisitor) isolateInstructions
mapClass = mapClass
phases = $(filterLabels) $(printer) $(testHarness) phases
printer = $(choices) printer
removeLoops = $(functionBodyVisitor) removeLoops
setClass = $(mapClass) setClass
shouldTransform = shouldTransform
skipVisitor = skipVisitor
stmtHash = stmtHash
stmtMap = $(mapClass) $(stmtHash) stmtMap
stmtSet = $(setClass) $(stmtHash) stmtSet
testHarness = testHarness
transformVisitor = $(backwardJumps) $(calls) $(classifyJumps) $(countdown) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(isolateInstructions) $(removeLoops) $(weighPaths) transformVisitor
utils = utils
weighPaths = $(stmtMap) weighPaths


########################################################################


cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libcil) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

harness := $(findFunction) $(phases) $(setClass) $(shouldTransform) $(transformVisitor) $(utils)
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

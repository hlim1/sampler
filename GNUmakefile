top := .
include defs.mk

targets := cfg-to-dot harness.$(cma)
subdirs := assignments libcountdown loads

include rules.mk


########################################################################


infile := hello


########################################################################


afterCalls = $(clonesMap) $(functionBodyVisitor) $(logIsImminent) afterCalls
backwardJumps = $(clonesMap) $(logIsImminent) backwardJumps
cfg = cfg
cfgToDot = $(dotify) cfgToDot
classifyJumps = $(functionBodyVisitor) $(stmtSet) classifyJumps
clonesMap = clonesMap
countdown = $(findGlobal) countdown
dotify = $(utils) dotify
duplicate = $(functionBodyVisitor) $(identity) $(stmtMap) duplicate
filterLabels = $(functionBodyVisitor) $(stmtSet) filterLabels
findFunction = $(findGlobal) findFunction
findGlobal = findGlobal
forwardJumps = $(clonesMap) forwardJumps
functionBodyVisitor = $(skipVisitor) functionBodyVisitor
functionEntry = $(logIsImminent) functionEntry
identity = identity
insertSkipsAfter = $(insertSkipsVisitor) insertSkipsAfter
insertSkipsBefore = $(insertSkipsVisitor) insertSkipsBefore
insertSkipsVisitor = $(functionBodyVisitor) $(where) insertSkipsVisitor
isolateInstructions = $(functionBodyVisitor) isolateInstructions
logIsImminent = $(countdown) logIsImminent
mapClass = mapClass
patchSites = patchSites
removeLoops = $(functionBodyVisitor) removeLoops
setClass = setClass
skipLog = $(findFunction) skipLog
skipVisitor = skipVisitor
stmtMap = $(mapClass) stmtMap
stmtSet = $(setClass) stmtSet
testHarness = testHarness
transformVisitor = $(afterCalls) $(backwardJumps) $(classifyJumps) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(insertSkipsVisitor) $(isolateInstructions) $(removeLoops) $(skipLog) $(weighPaths) transformVisitor
utils = utils
weighPaths = $(stmtMap) weighPaths
where = where


########################################################################


cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libcil) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

harness := $(filterLabels) $(insertSkipsAfter) $(insertSkipsBefore) $(testHarness) $(transformVisitor)
harness.$(cma): $(addsuffix .$(cmo), $(harness))
	$(archive)

checker: %: $(libcil) $(addsuffix .$(cmo), %)
	$(link)

dump: %: $(libcil) $(addsuffix .$(cmo), %)
	$(link)

$(libcil): force
	$(MAKE) -C $(cildir) -f Makefile.cil NATIVECAML=$(native) cillib

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

targets := cfg-to-dot harness.cma
top := .
subdirs := heapStores

include rules.mk


########################################################################


infile := hello


########################################################################


afterCalls = $(functionBodyVisitor) $(logIsImminent) afterCalls
backwardJumps = $(logIsImminent) backwardJumps
cfg = cfg
cfgToDot = $(dotify) cfgToDot
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
logIsImminent = $(countdown) logIsImminent
mapClass = mapClass
patchSites = patchSites
removeLoops = $(functionBodyVisitor) removeLoops
setClass = setClass
skipVisitor = skipVisitor
stmtMap = $(mapClass) stmtMap
stmtSet = $(setClass) stmtSet
testHarness = testHarness
transformVisitor = $(afterCalls) $(backwardJumps) $(classifyJumps) $(duplicate) $(forwardJumps) $(functionBodyVisitor) $(functionEntry) $(removeLoops) $(weighPaths) transformVisitor
utils = utils
weighPaths = $(stmtMap) weighPaths


########################################################################


cfg_to_dot := $(cfg) $(cfgToDot) $(functionBodyVisitor) $(testHarness) %
cfg-to-dot: %: $(libcil) $(addsuffix .$(cmo), $(cfg_to_dot))
	$(link)

harness := $(filterLabels) $(logWrite) $(testHarness) $(transformVisitor)
harness.cma: $(addsuffix .$(cmo), $(harness))
	$(link) -a

checker: %: $(addsuffix .$(cmo), %)
	$(link)

dump: %: $(addsuffix .$(cmo), %)
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

top := ..
include $(top)/defs.mk

libdirs := $(top)
targets := logging.$(cma)
subdirs := assignments heapStores loads localVars

include $(top)/rules.mk


########################################################################


logCollector = $(logger) $(outputSet) logCollector
dissect = $(outputSet) dissect
logger = $(outputSet) logger
outputHash = outputHash
outputSet = $(outputHash) outputSet


########################################################################


logging := $(dissect) $(logCollector)
logging.$(cma): $(libcil) $(top)/harness.$(cma) $(addsuffix .$(cmo), $(logging))
	$(archive)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

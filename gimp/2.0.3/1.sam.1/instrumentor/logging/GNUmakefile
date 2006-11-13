top := ..
include $(top)/defs.mk

libdirs := $(top)
targets := logging.$(cma)
subdirs := assignments heapStores loads localVars

include $(top)/rules.mk


########################################################################


logging := $(dissect) $(logCollector)
logging.$(cma): ../harness.$(cma) $(logging)
	$(archive)

../%.cma: $(force)
	$(recurse)

../%.cmi: $(top)/harness.$(cma)

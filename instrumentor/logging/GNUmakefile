top := ..
include $(top)/defs.mk

libdirs := $(top)
targets := logging.$(cma)
subdirs := assignments heapStores loads localVars

include $(top)/rules.mk


########################################################################


logging := $(dissect) $(logCollector)
logging.$(cma): $(libcil) $(top)/harness.$(cma) $(logging)
	$(archive)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := liblog

include $(top)/rules.mk


########################################################################


bitFields = bitFields
checkSimplicity = $(bitFields) checkSimplicity
findSites = findSites
heapStoresTransform = $(findSites) $(instrument) $(simplify) $(stores) heapStoresTransform
instrument = $(functionBodyVisitor) $(logWrite) instrument
logWrite = logWrite
simplify = $(simplifyLefts) $(simplifyReturns) $(simplifyRights) $(checkSimplicity) simplify
simplifyLefts = $(bitFields) $(simplifyVisitor) simplifyLefts
simplifyReturns = $(simplifyVisitor) simplifyReturns
simplifyRights = $(simplifyVisitor) simplifyRights
simplifyVisitor = simplifyVisitor
stores = stores


########################################################################


main := $(heapStoresTransform) %
main: %: $(libcil) $(top)/harness.$(cma) $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

run: main $(infile).i
	./$^
.PHONY: run

top := ../..
include $(top)/defs.mk

targets := main
libdirs := .. $(top)
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


log = $(findOutputs) $(simplify) log
bitFields = bitFields
checkSimplicity = $(bitFields) checkSimplicity
findOutputs = findOutputs
transform = $(log) transform
simplify = $(simplifyLefts) $(simplifyReturns) $(simplifyRights) $(checkSimplicity) simplify
simplifyLefts = $(bitFields) $(simplifyVisitor) simplifyLefts
simplifyReturns = $(simplifyVisitor) simplifyReturns
simplifyRights = $(simplifyVisitor) simplifyRights
simplifyVisitor = simplifyVisitor


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.$(cma) ../logging.$(cma) $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

../%.cma: force
	$(recurse)

../%.cmi: force
	$(recurse)

run: main $(infile).i
	./$^
.PHONY: run

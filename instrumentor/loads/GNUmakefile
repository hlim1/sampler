top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


collect = $(dissect) $(outputSet) collect
findSites = $(collect) $(outputSet) findSites
transform = $(findSites) transform


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.$(cma) $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

run: main $(infile).i
	./$^
.PHONY: run

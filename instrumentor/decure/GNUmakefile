top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


findSites = findSites
transform = $(findSites) transform


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.$(cma) $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

../%.cma: force
	$(recurse)

../%.cmi: force
	$(recurse)


########################################################################


infile := tests/echocured


run: main $(infile).i
	./$^
.PHONY: run

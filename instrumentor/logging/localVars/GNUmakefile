top := ../..
include $(top)/defs.mk

targets := main
subdirs := tests
libdirs := .. $(top)
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


collect = collect
findOutputs = $(collect) findOutputs
log = $(collect) $(findOutputs) log
transform = $(log) transform


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

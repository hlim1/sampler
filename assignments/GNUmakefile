top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := liblog
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


findLogger = findLogger
findSites = $(logs) findSites
logs = logs
skips = $(functionBodyVisitor) skips
transform = $(findLogger) $(findSites) transform


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

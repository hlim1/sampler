top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := liblog
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


findLogger = findLogger
findSites = findSites
logs = $(findSites) logs
skips = $(functionBodyVisitor) skips
transform = $(findLogger) $(findSites) $(logs) transform


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

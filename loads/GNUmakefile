top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := liblog
syslibs := str.$(cma)

include $(top)/rules.mk


########################################################################


collect = $(dissect) $(outputSet) collect
dissect = $(outputSet) dissect
findLogger = findLogger
findSites = $(collect) $(outputSet) findSites
logs = $(findSites) $(outputSet) $(where) logs
outputSet = outputSet
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

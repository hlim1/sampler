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
logs = $(collect) $(where) logs
outputSet = outputSet
skips = $(functionBodyVisitor) skips
transform = $(findLogger) $(logs) $(skips) $(weigh) transform
weigh = weigh
where = where


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

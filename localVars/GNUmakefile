top := ..
targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


findLoggers = $(loggers) findLoggers
loggers = loggers
logs = $(where) logs
skips = $(functionBodyVisitor) skips
transform = $(findLoggers) $(logs) $(skips) transform
where = where


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.cma $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

run: main $(infile).i
	./$^
.PHONY: run

top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


main: %: $(libcil) $(top)/harness.$(cma) $(main)
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

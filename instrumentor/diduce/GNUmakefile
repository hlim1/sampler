top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.$(cma) $(main)
	$(link)

$(top)/%.cma: $(force)
	$(recurse)

$(top)/%.cmi: $(force)
	$(recurse)

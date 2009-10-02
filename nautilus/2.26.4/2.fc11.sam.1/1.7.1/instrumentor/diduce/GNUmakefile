top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


main := $(transform) %
main: %: $(libcil) ../harness.$(cma) $(main)
	$(link)

../%.cma: $(force)
	$(recurse)

../%.cmi: ../harness.$(cma)

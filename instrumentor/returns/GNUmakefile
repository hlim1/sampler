top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := libreturns tests

include $(top)/rules.mk


########################################################################


libharness := $(libcil) $(top)/harness.$(cma)


main: $(libharness) $(main)
	$(link)

$(top)/%.cmi: $(top)/harness.$(cma)

$(top)/%.cma: $(force)
	$(recurse)

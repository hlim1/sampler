top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := libdaikon

include $(top)/rules.mk


########################################################################


libharness := $(libcil) $(top)/harness.$(cma)


main: $(libharness) $(main)
	$(link)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.cma: $(force)
	$(recurse)

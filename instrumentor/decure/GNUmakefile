top := ..
include $(top)/defs.mk

targets := main filterComplete listCandidates
subdirs := tests
libdirs := $(top)

include $(top)/rules.mk


########################################################################


libharness := $(libcil) ../harness.$(cma)


main: $(libharness) $(main)
	$(link)

filterComplete: $(libharness) $(filterComplete)
	$(link)

listCandidates: $(libharness) $(listCandidates)
	$(link)

../%.cmi: ../harness.$(cma)

../%.cma: $(force)
	$(recurse)

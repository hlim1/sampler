top := ..
include $(top)/defs.mk

targets := main
#subdirs := tests
libdirs := $(top)

include $(top)/rules.mk


########################################################################


main: $(libcil) $(top)/harness.$(cma) $(main)
	$(link)

filterComplete: $(filterComplete)
	$(link)

listCandidates: $(listCandidates)
	$(link)

$(top)/%.cmi: $(force)
	$(recurse)

top := ..
include $(top)/defs.mk

targets := daikount.$(cma)
libdirs := $(top)
subdirs := libdaikount returns scalar-pairs

include $(top)/rules.mk


########################################################################


daikount.$(cma): $(prepareDaikount)
	$(archive)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.cma: $(force)
	$(recurse)

top := ..
include $(top)/defs.mk

targets := daikount.$(cma)
libdirs := $(top)
subdirs := libdaikount scalar-pairs

include $(top)/rules.mk


########################################################################


daikount.$(cma): ../harness.$(cma) $(prepareDaikount)
	$(archive)

../%.cmi: ../harness.$(cma)

../%.cma: $(force)
	$(recurse)

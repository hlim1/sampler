top := ..
include $(top)/defs.mk

targets := fun-patch.$(cma)
libdirs := $(top)
subdirs := basis

include $(top)/rules.mk


########################################################################


fun_patch := $(mangler)
fun-patch.$(cma): ../harness.$(cma) $(fun_patch)
	$(archive)

../%.$(cma): $(force)
	$(recurse)

../%.cmi: ../harness.$(cma)

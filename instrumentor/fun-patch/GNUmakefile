top := ..
include $(top)/defs.mk

targets := fun-patch.$(cma)
libdirs := $(top)
subdirs := basis

include $(top)/rules.mk


########################################################################


fun_patch := $(mangler)
fun-patch.$(cma): $(top)/harness.$(cma) $(fun_patch)
	$(archive)

$(top)/%.cma: $(force)
	$(recurse)

$(top)/%.cmi: $(force)
	$(recurse)

top := ../..
include $(top)/defs.mk

targets := main
libdirs := $(top) ..
subdirs := tests

include $(top)/rules.mk


########################################################################


libs := $(libcil) $(top)/harness.$(cma) ../daikount.$(cma)

main: $(libs) $(main)
	$(link)

 ../daikount.$(cma): $(force)
	$(recurse)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.cma: $(force)
	$(recurse)

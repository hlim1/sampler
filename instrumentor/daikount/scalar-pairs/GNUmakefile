top := ../..
include $(top)/defs.mk

targets := main
libdirs := $(top) ..
subdirs := tests

include $(top)/rules.mk


########################################################################


libs := $(libcil) ../daikount.$(cma)

main: $(libs) $(main)
	$(link)

 ../daikount.$(cma): $(force)
	$(recurse)

../%.cmi: ../daikount.$(cma)

../../%.cmi: ../daikount.$(cma)

top := ../..
include $(top)/defs.mk

targets := main
#subdirs := tests
libdirs := .. $(top)

include $(top)/rules.mk


########################################################################


main: %: $(libcil) ../logging.$(cma) $(main)
	$(link)

../%.cma: $(force)
	$(recurse)

../%.cmi: ../logging.$(cma)

../../%.cmi: ../logging.$(cma)

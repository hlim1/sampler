top := ../..
include $(top)/defs.mk

targets := main
libdirs := .. $(top)

include $(top)/rules.mk


########################################################################


main: $(libcil) $(top)/harness.$(cma) ../decure.$(cma) $(main)
	$(link)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.$(cma): $(force)
	$(recurse)

../%.cmi: $(force)
	$(recurse)

../%.$(cma): $(force)
	$(recurse)

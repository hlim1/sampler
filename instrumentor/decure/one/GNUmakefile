top := ../..
include $(top)/defs.mk

targets := filterComplete listCandidates main
libdirs := .. $(top)

include $(top)/rules.mk


########################################################################


libs := $(libcil) $(top)/harness.$(cma) ../decure.$(cma)


main: $(libs) $(main)
	$(link)

listCandidates: $(libs) $(listCandidates)
	$(link)

filterComplete: $(libs) $(filterComplete)
	$(link)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.$(cma): $(force)
	$(recurse)

../%.cmi: $(force)
	$(recurse)

../%.$(cma): $(force)
	$(recurse)

SUBDIRS = tests
targets = main

include ../rules.mk


libharness = ../harness.$(cma)
libdirs += ..

../%.cmi: $(libharness)

%.cma: $(force)
	$(recurse)


main: $(libcil) $(libharness) $(main)
	$(link)

filterComplete: $(libcil) $(libharness) $(filterComplete)
	$(link)

listCandidates: $(libcil) $(libharness) $(listCandidates)
	$(link)

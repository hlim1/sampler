top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)
subdirs := libdaikon

include $(top)/rules.mk


########################################################################


libharness := $(libcil) $(top)/harness.$(cma)


main: $(libharness) $(main)
	$(link)

$(top)/%.cmi: $(force)
	$(recurse)

$(top)/%.cma: $(force)
	$(recurse)

test.i: CC := $(CC)
test.i: test.c libdaikon/daikon.h
	$(CPP) $< >$@

test-daikon.c: main test.i
	./$^ | egrep -v '^#' >$@ || rm -f $@
	[ -r $@ ]

test-daikon: test-daikon.c libdaikon/libdaikon.la
test-daikon: CC := libtool $(CC)
test-daikon: LOADLIBES := -L../../libcountdown -lcyclic

libdaikon/libdaikon.la: force
	$(recurse)

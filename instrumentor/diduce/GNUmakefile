top := ..
include $(top)/defs.mk

targets := main
libdirs := $(top)

include $(top)/rules.mk


########################################################################


formals = $(mapconcat) $(tracker) formals
mapconcat = mapconcat
returns = $(tracker) returns
transform = $(formals) $(mapconcat) $(returns) $(tracker) transform
tracker = tracker


########################################################################


main := $(transform) %
main: %: $(libcil) $(top)/harness.$(cma) $(addsuffix .$(cmo), $(main))
	$(link)

$(top)/%.cma: force
	$(recurse)

$(top)/%.cmi: force
	$(recurse)

EXTRA_DIST =					\
	find-implicits				\
	find-unused				\
	link-order				\
	rules.mk

include $(top_srcdir)/ocaml/rules.mk


all-local: common.$(cma)


common =					\
	$(fixpoint)				\
	$(hashClass)				\
	$(mapClass)				\
	$(queueClass)				\
	$(stringHash)				\
	$(stackClass)

common.$(cma): $(common)
	$(archive)

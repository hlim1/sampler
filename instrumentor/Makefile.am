SUBDIRS =					\
	driver					\
	balance					\
	bounds					\
	branches				\
	function-entries			\
	g-object-unref				\
	nothing					\
	returns					\
	scalar-pairs				\
	timestamps

EXTRA_DIST = build-libraries libraries.ml.in

targets = harness.$(cma)
extra_impls = libraries version

include $(top_srcdir)/ocaml/rules.mk

libdirs += $(top_builddir)/ocaml
syslibs = str.$(cma) unix.$(cma)

instrumentor_SCRIPTS = main


libraries.ml: %: build-libraries %.in
	./$^ >$@

$(dir $(libcommon))%.cmi: $(libcommon); @:
$(libcommon): $(force); $(recurse)

main: $(libcil) $(libcommon) $(main)
	$(link)

cfgTest: $(libcil) $(cfgTest)
	$(link)

cfg-to-dot: $(libcil) $(cfg-to-dot)
	$(link)

checker: $(libcil) $(checker)
	$(link)

dump: $(libcil) $(dump)
	$(link)

removeDeadCode: $(libcil) $(removeDeadCode)
	$(link)

simplify: $(libcil) $(simplify)
	$(link)

loopless: $(libcil) $(loopless)
	$(link)

check-local: main

.DELETE_ON_ERROR:

SUBDIRS =					\
	driver					\
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

%.i: %.c
	$(CC) -I$(top_srcdir)/lib $(CPPFLAGS) $(CFLAGS) -E $< -o $@

%.cfg.dot: cfg-to-dot %.i
	./$^ >$@

%.dom.dot: dom-to-dot %.i
	./$^ >$@

%.ps: %.dot
	dot -Tps -Gsize=7.5,10 -Gcenter=1 -o $@ $<

calls.cfg: %.cfg: %.cfg.o
	$(top_srcdir)/tools/extract-section .debug_sampler_cfg $< >$@

calls.cfg.i: %.cfg.i: cfgTest %.c
	./$^ >$@

%.o: %.i
	$(CC) -c $<

.DELETE_ON_ERROR:

unbalanced.clean.i: %.clean.i: %.inst.i
	egrep -v '^#' $< | indent >$@

unbalanced.inst.i: %.inst.i: %.c main
	driver/sampler-cc-here -save-temps --sampler-scheme=returns -c $<

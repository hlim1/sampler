SUBDIRS = driver branches nothing returns scalar-pairs

EXTRA_DIST = build-libraries libraries.ml.in

targets = harness.$(cma)
extra_impls = libraries version

include $(top_srcdir)/ocaml/rules.mk

libdirs += $(top_builddir)/ocaml branches
syslibs = str.$(cma) unix.$(cma)


all-local: main

libraries.ml: %: build-libraries %.in
	./$^ >$@.tmp
	mv $@.tmp $@

main = main.$(cmo)
main: $(libcil) $(libcommon) harness.$(cma) main.$(cmo)
	$(link)

harness = $(counterTuples) $(siteFinder) $(phases)
harness.$(cma): $(harness)
	$(archive)

$(dir $(libcommon))%.cmi: $(libcommon); @:
$(libcommon): $(force); $(recurse)

libbranches := branches/branches.cma
$(dir $(libbranches))%.cmi: $(libbranches); @:
$(libbranches): $(force); $(recurse)

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
	$(top_srcdir)/tools/extract-section .debug_sampler_cfg $< >$@.tmp
	mv $@.tmp $@

calls.cfg.i: %.cfg.i: cfgTest %.c
	./$^ >$@.tmp
	mv $@.tmp $@

%.o: %.i
	$(CC) -c $<

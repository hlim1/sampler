SUBDIRS = driver branches daikon decure nothing returns scalar-pairs #logging

EXTRA_DIST = build-libraries defs.mk fixdeps libraries.ml.in rules.mk

targets = harness.$(cma)
extra_impls = libraries

include rules.mk


libraries.ml: %: build-libraries %.in
	./$^ >$@.tmp
	mv $@.tmp $@

harness = $(manager) $(phases) $(tuples) $(bumper) $(bumpSign) $(describedExpression) $(int64Set)
harness.$(cma): $(harness)
	$(archive)

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

%.cfg.dot: cfg-to-dot %.i
	./$^ >$@

%.dom.dot: dom-to-dot %.i
	./$^ >$@

%.ps: %.dot
	dot -Tps -Gsize=7.5,10 -Gcenter=1 -o $@ $<

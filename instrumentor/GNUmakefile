top := .
include defs.mk

targets := cfg-to-dot checker dump harness.$(cma)
subdirs := decure driver logging

include rules.mk


########################################################################


cfg-to-dot: $(libcil) $(cfg_to_dot)
	$(link)

harness := $(findFunction) $(phases) $(setClass) $(shouldTransform) $(transformVisitor) $(utils)
harness.$(cma): $(harness)
	$(archive)

checker: $(libcil) $(checker)
	$(link)

dump: $(libcil) $(dump)
	$(link)

%.i: %.c
	$(CC) $(CPPFLAGS) $< -o $@ -E

%.d: %.c
	$(CC) $(CPPFLAGS) $< -o $*.i -M >$@

%.cfg.dot: cfg-to-dot %.i
	./$^ >$@

%.dom.dot: dom-to-dot %.i
	./$^ >$@

%.ps: %.dot
	dot -Tps -Gsize=7.5,10 -Gcenter=1 -o $@ $<

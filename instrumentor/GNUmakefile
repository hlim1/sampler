top := .
include defs.mk

targets := cfg-to-dot checker dump harness.$(cma)
subdirs := decure logging

include rules.mk


########################################################################


live += $(cfg_to_dot)
cfg-to-dot: $(libcil) $(cfg_to_dot)
	$(link)

harness := $(phases)
live += $(harness)
harness.$(cma): $(harness)
	$(archive)

live += $(checker)
checker: $(libcil) $(checker)
	$(link)

live += $(dump)
dump: $(libcil) $(dump)
	$(link)

live += $(removeDeadCode)
removeDeadCode: $(libcil) $(removeDeadCode)
	$(link)

live += $(loopless)
loopless: $(libcil) $(loopless)
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

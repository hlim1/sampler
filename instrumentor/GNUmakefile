top := .
include defs.mk

targets := cfg-to-dot checker dump harness.$(cma) loopless
subdirs := branches daikon daikount decure nothing #logging

include rules.mk


########################################################################


cfg-to-dot: $(libcil) $(cfg-to-dot)
	$(link)
live += $(cfg-to-dot)

harness := $(manager) $(phases) $(siteInfoQueue)
harness.$(cma): $(harness)
	$(archive)
live += $(harness)

checker: $(libcil) $(checker)
	$(link)
live += $(checker)

dump: $(libcil) $(dump)
	$(link)
live += $(dump)

removeDeadCode: $(libcil) $(removeDeadCode)
	$(link)
live += $(removeDeadCode)

loopless: $(libcil) $(loopless)
	$(link)
live += $(loopless)

dumpConstants: $(libcil) $(dumpConstants)
	$(link)
live += $(dumpConstants)

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


########################################################################


GNUmakefile: libraries.ml

libraries.ml: %: build-libraries %.in
	./$< >$@.
	mv $@. $@


########################################################################


gc: gc-ml gc-mli

gc-ml:
	@echo dead ml: $(filter-out $(live:.cmo=.ml), $(wildcard *.ml))

gc-mli:
	@echo dead mli: $(filter-out $(live:.cmo=.mli), $(wildcard *.mli))

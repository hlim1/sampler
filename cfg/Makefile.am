noinst_SCRIPTS = resolve-cfg

EXTRA_DIST =

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += $(noinst_SCRIPTS)

includes += -pp camlp4o
libdirs += $(dir $(libcommon))


resolve-cfg: $(libcil) $(libcommon) $(resolve-cfg)
	$(link)

$(dir $(libcommon))/%.cmi: $(libcommon)

$(libcommon): $(force)
	$(recurse)

#input := /usr/lib/sampler/sites/usr/lib/sampler/applications/evolution/executable.cfg
input := tiny.cfg

sampler_cc := $(top_builddir)/instrumentor/driver/sampler-cc-here
nothing := $(top_builddir)/instrumentor/nothing/main

test: resolve-cfg $(input)
	time ./$^

MOSTLYCLEANFILES += *.cfg

tiny.cfg: tiny.o
	$(top_srcdir)/tools/extract-section .debug_sampler_cfg $< >$@.tmp
	mv $@.tmp $@

tiny.o: tiny.c $(sampler_cc) $(nothing)
	$(sampler_cc) nothing -c $<

$(sampler_cc) $(nothing): force
	$(MAKE) -C $(@D) $(@F)

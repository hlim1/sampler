SUBDIRS = graphlib

tools_SCRIPTS = resolve-cfg order-sites find-cliff

EXTRA_DIST =

include $(top_srcdir)/ocaml/rules.mk

MOSTLYCLEANFILES += $(noinst_SCRIPTS)

libgraph = graphlib/graphlib.$(cma)

includes += -pp camlp4o
libdirs += $(dir $(libcommon) $(libgraph))
syslibs = unix.$(cma)


resolve-cfg: $(libcommon) $(libgraph) $(resolve-cfg)
	$(link)

order-sites: $(libcommon) $(libgraph) $(order-sites)
	$(link)

find-cliff: $(libcommon) $(libgraph) $(find-cliff)
	$(link)

$(dir $(libcommon))/%.cmi: $(libcommon); @:

$(dir $(libgraph))/%.cmi: $(libgraph); @:

$(libcommon) $(libgraph): $(force)
	$(recurse)

cfg := /usr/lib/sampler/sites/usr/lib/sampler/applications/evolution/executable.cfg
sites := evolution-sites.txt

#cfg := tiny.cfg
#sites := sites-list.txt

sampler_cc := $(top_builddir)/instrumentor/driver/sampler-cc-here
nothing := $(top_builddir)/instrumentor/nothing/main

test: order-sites $(cfg)
	./$^ <$(sites)

MOSTLYCLEANFILES += *.cfg

tiny.cfg: tiny.o
	$(top_srcdir)/tools/extract-section .debug_sampler_cfg $< >$@.tmp
	mv $@.tmp $@

tiny.o: tiny.c $(sampler_cc) $(nothing)
	$(sampler_cc) nothing -c $<

$(sampler_cc) $(nothing): force
	$(MAKE) -C $(@D) $(@F)

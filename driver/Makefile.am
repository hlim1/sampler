bin_SCRIPTS = sampler-cc
driver_SCRIPTS = as cc1
driver_DATA = sampler-specs
noinst_SCRIPTS = sampler-cc-here

EXTRA_DIST = $(driver_DATA)

MOSTLYCLEANFILES =				\
	main					\
	sampler					\
	stamp-links


all-local: stamp-links

stamp-links:
	rm -f $(MOSTLYCLEANFILES)
	$(LN_S) $(top_srcdir)/instrumentor/main main
	$(LN_S) $(top_srcdir)/lib sampler
	touch $@

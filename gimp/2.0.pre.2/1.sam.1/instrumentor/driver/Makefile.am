bin_SCRIPTS = sampler-cc
driver_SCRIPTS = as cc1
driver_DATA = sampler-specs

EXTRA_DIST = sampler-cc-here $(driver_DATA)

MOSTLYCLEANFILES =				\
	include					\
	libsampler.a				\
	libsampler_r.a				\
	libschemes.a				\
	sampler					\
	stamp-links


all-local: stamp-links

stamp-links:
	rm -f $(MOSTLYCLEANFILES)
	$(LN_S) $(srcdir) include
	$(LN_S) $(top_srcdir)/lib sampler
	$(LN_S) $(top_builddir)/lib/libsampler.a .
	$(LN_S) $(top_builddir)/lib/libsampler_r.a .
	$(LN_S) $(top_builddir)/lib/libschemes.a .
	touch $@

bin_SCRIPTS = sampler-cc
driver_SCRIPTS = as cc1
driver_DATA = sampler-specs

EXTRA_DIST = sampler-cc-here $(driver_DATA)

MOSTLYCLEANFILES =				\
	include					\
	libsampler.a				\
	libsampler-no-threads.a			\
	libsampler-threads.a			\
	sampler					\
	stamp-links


all-local: stamp-links

stamp-links:
	rm -f $(MOSTLYCLEANFILES)
	$(LN_S) $(srcdir) include
	$(LN_S) $(top_srcdir)/lib sampler
	$(LN_S) $(top_builddir)/lib/libsampler.a .
	$(LN_S) $(top_builddir)/lib/libsampler-no-threads.a .
	$(LN_S) $(top_builddir)/lib/libsampler-threads.a .
	touch $@

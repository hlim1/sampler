bin_SCRIPTS = sampler-cc
driver_SCRIPTS = cc1 sampler-cc-here
driver_DATA = sampler-specs

EXTRA_DIST = sampler-cc-here $(driver_DATA)

MOSTLYCLEANFILES = libsampler.a libsampler_r.a sampler stamp-links


all-local: stamp-links

stamp-links:
	rm -f $(MOSTLYCLEANFILES)
	$(LN_S) ../../lib/libsampler.a ../../lib/libsampler_r.a .
	$(LN_S) $(top_srcdir)/lib sampler
	touch $@

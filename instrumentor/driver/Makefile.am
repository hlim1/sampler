bin_SCRIPTS = sampler-cc
driver_SCRIPTS = cc1 sampler-cc-here
driver_DATA = sampler-specs

EXTRA_DIST = sampler-cc-here $(driver_DATA)


all-local: include stamp-link-libs

include:
	$(LN_S) ../../lib $@

stamp-link-libs:
	$(LN_S) ../../lib/libsampler.a ../../lib/libsampler_r.a .
	touch $@

MOSTLYCLEANFILES = include libsampler.a libsampler_r.a stamp-link-libs

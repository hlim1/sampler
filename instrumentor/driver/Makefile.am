bin_SCRIPTS = sampler-cc
driver_SCRIPTS = cc1 sampler-cc-here
driver_DATA = sampler-specs

EXTRA_DIST = sampler-cc-here $(driver_DATA)


all-local: include libsampler.a libsampler_r.a

include:
	$(LN_S) ../../lib $@

libsampler.a libsampler_r.a:
	$(LN_S) ../../lib/$@ $@

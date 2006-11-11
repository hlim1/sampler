bin_SCRIPTS = sampler-cc
driver_SCRIPTS = as cc1
driver_DATA = sampler-specs
noinst_SCRIPTS = sampler-cc-here

EXTRA_DIST = $(driver_DATA)

dist-hook:
	cp -pd main sampler $(distdir)


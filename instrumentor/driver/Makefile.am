bin_SCRIPTS = sampler-cc
driver_SCRIPTS = main
driver_DATA = CillySampler.pm Sampler.pm

EXTRA_DIST = $(driver_DATA)

main: main-subst
	chmod +x $<
	cp $< $@

bin_SCRIPTS = sampler-cc
instrumentor_SCRIPTS = main
instrumentor_DATA = CillySampler.pm Sampler.pm

EXTRA_DIST = $(instrumentor_DATA)

main: main-subst
	chmod +x $<
	cp $< $@

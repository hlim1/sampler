bin_SCRIPTS = sampler-cc
driver_SCRIPTS = main

driver_extras =					\
	../cil/lib/Cilly.pm			\
	../cil/lib/KeptFile.pm			\
	../cil/lib/OutputFile.pm		\
	../cil/lib/TempFile.pm			\
	CillySampler.pm				\
	Sampler.pm

EXTRA_DIST = CillySampler.pm Sampler.pm

main: main-subst
	chmod +x $<
	cp $< $@

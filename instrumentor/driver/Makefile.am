bin_SCRIPTS = sampler-cc
driver_SCRIPTS = main

cillib_DATA =					\
	../cil/lib/Cilly.pm			\
	../cil/lib/KeptFile.pm			\
	../cil/lib/OutputFile.pm		\
	../cil/lib/TempFile.pm

driver_DATA =					\
	CillySampler.pm				\
	Sampler.pm

EXTRA_DIST = $(driver_DATA)

main: main-subst
	chmod +x $<
	cp $< $@

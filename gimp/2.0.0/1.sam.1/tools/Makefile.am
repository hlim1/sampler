SUBDIRS = cfg

tools_PROGRAMS =				\
	decimate-samples

tools_SCRIPTS =					\
	debuild					\
	Embedded.pm				\
	Function.pm				\
	Node.pm					\
	Object.pm				\
	RawSamples.pm				\
	SiteInfo.pm				\
	SymbolTable.pm				\
	TaggedLoader.pm				\
	Unit.pm					\
	extract-report				\
	extract-section				\
	find-sampler-info			\
	resolve-cfg				\
	resolve-samples				\
	rpmbuild

EXTRA_DIST =					\
	Embedded.pm				\
	Function.pm				\
	Node.pm					\
	Object.pm				\
	RawSamples.pm				\
	SiteInfo.pm				\
	SymbolTable.pm				\
	TaggedLoader.pm				\
	Unit.pm					\
	extract-report				\
	extract-section				\
	find-driver.pl				\
	find-sampler-info			\
	resolve-cfg				\
	resolve-samples				\
	skip-test

rpmbuild debuild: find-driver.pl

AM_LFLAGS = -f -p
AM_CFLAGS = -W -Wall -Werror

decimate_samples_SOURCES = decimate-samples.l
decimate_samples_CFLAGS = $(GSL_CFLAGS)
decimate_samples_LDADD = $(GSL_LIBS) $(LEXLIB)

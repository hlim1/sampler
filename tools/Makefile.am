SUBDIRS = cfg

tools_PROGRAMS =				\
	decimate-samples

tools_SCRIPTS =					\
	debuild					\
	Embedded.pm				\
	Function.pm				\
	Node.pm					\
	Object.pm				\
	SymbolTable.pm				\
	Unit.pm					\
	extract-report				\
	extract-section				\
	find-sampler-info			\
	resolve-cfg				\
	resolve-samples				\
	resolve-timestamps			\
	rpmbuild

EXTRA_DIST =					\
	Embedded.pm				\
	Function.pm				\
	Node.pm					\
	Object.pm				\
	SymbolTable.pm				\
	Unit.pm					\
	extract-report				\
	extract-section				\
	find-driver.pl				\
	find-sampler-info			\
	resolve-cfg				\
	skip-test

rpmbuild debuild: find-driver.pl

AM_LFLAGS = -f -p
AM_CFLAGS = -W -Wall -Werror

decimate_samples_SOURCES = decimate-samples.l
decimate_samples_CFLAGS = $(GSL_CFLAGS)
decimate_samples_LDADD = $(GSL_LIBS) $(LEXLIB)

include $(top_srcdir)/ocaml.mk.in

libdirs += $(top_builddir)/ocaml
syslibs = str.$(cma) unix.$(cma)

CLEANFILES += resolve-samples resolve-timestamps

resolve-samples: $(libcommon) $(resolve-samples)
	$(link)

resolve-timestamps: $(libcommon) $(resolve-timestamps)
	$(link)

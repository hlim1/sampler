SUBDIRS = cfg

if DISTRO_BASIS_RPM
distro_scripts = rpmbuild
endif

if DISTRO_BASIS_DEBIAN
distro_data = sampler.mk
endif

tools_PROGRAMS =				\
	decimate-samples

tools_DATA =					\
	$(distro_data)				\
	Embedded.pm				\
	Function.pm				\
	Node.pm					\
	Object.pm				\
	SymbolTable.pm				\
	Unit.pm

tools_SCRIPTS =					\
	$(distro_scripts)			\
	extract-report				\
	extract-section				\
	find-sampler-info			\
	resolve-cfg				\
	resolve-samples				\
	resolve-timestamps

EXTRA_DIST =					\
	$(tools_DATA)				\
	extract-report				\
	extract-section				\
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

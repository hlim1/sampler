SUBDIRS = cfg

if DISTRO_BASIS_RPM
distro_scripts = rpmbuild
endif

if DISTRO_BASIS_DEBIAN
distro_data = sampler.mk
distro_scripts =				\
	add-depends				\
	build-control
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
	Unit.pm					\
	application.schemas.in			\
	wrapper.in

tools_SCRIPTS =					\
	$(distro_scripts)			\
	extract-report				\
	extract-section				\
	find-sampler-info			\
	install-gconf				\
	install-wrappers			\
	resolve-cfg				\
	resolve-samples				\
	resolve-timestamps

EXTRA_DIST =					\
	$(tools_DATA)				\
	application.schemas.in			\
	extract-report				\
	extract-section				\
	find-sampler-info			\
	resolve-cfg				\
	skip-test				\
	wrapper.in.in

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

wrapper.in: %: %.in
	sed							\
		-e 's!@''pkgdatadir@!$(pkgdatadir)!'		\
		-e 's!@''pkglibdir@!$(pkglibdir)!'		\
		-e 's!@''PACKAGE_VERSION@!$(PACKAGE_VERSION)!'		\
		-e 's!@''DISTRO_NAME@!$(DISTRO_NAME)!'		\
		-e 's!@''DISTRO_VERSION@!$(DISTRO_VERSION)!'		\
		-e 's!@''DISTRO_ARCH@!$(DISTRO_ARCH)!'		\
		<$< >$@

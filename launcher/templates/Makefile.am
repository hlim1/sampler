templates_SCRIPTS =				\
	install-wrappers

templates_DATA =				\
	application.schemas.in			\
	config.in				\
	wrapper.in

EXTRA_DIST =					\
	application.schemas.in			\
	config.in.in				\
	wrapper.in.in

config.in: %: %.in
	sed							\
		-e 's!@''pkgdatadir@!$(pkgdatadir)!'		\
		-e 's!@''PACKAGE_VERSION@!$(PACKAGE_VERSION)!'		\
		-e 's!@''DISTRO_NAME@!$(DISTRO_NAME)!'		\
		-e 's!@''DISTRO_VERSION@!$(DISTRO_VERSION)!'		\
		-e 's!@''DISTRO_ARCH@!$(DISTRO_ARCH)!'		\
		<$< >$@

wrapper.in: %: %.in
	sed							\
		-e 's!@''pkgdatadir@!$(pkgdatadir)!'		\
		-e 's!@''pkglibdir@!$(pkglibdir)!'		\
		<$< >$@

SUBDIRS =					\
	common					\
	first-time				\
	monitor					\
	pixmaps					\
	preferences				\
	tray					\
	wrapper

if !HAVE_PYTHON_TRAYICON
SUBDIRS += trayicon
endif !HAVE_PYTHON_TRAYICON

schema_DATA = sampler.schemas

noinst_SCRIPTS = test-by-extension

EXTRA_DIST =					\
	$(pkgdata_DATA)				\
	$(pkgdata_SCRIPTS)			\
	$(schema_DATA)				\
	gconf-1.0.dtd

TESTS = $(schema_DATA)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

install-data-hook:
if GCONF_SCHEMAS_INSTALL
	GCONF_CONFIG_SOURCE=$(GCONF_SCHEMA_CONFIG_SOURCE) gconftool-2 --makefile-install-rule $(schemadir)/$(schema_DATA) >/dev/null
endif

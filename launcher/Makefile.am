SUBDIRS =					\
	broken					\
	common					\
	first-time				\
	monitor					\
	pixmaps					\
	tray					\
	trayicon				\
	wrapper

package_data_DATA = gdb-commands
package_data_SCRIPTS = print-debug-info

schema_DATA = sampler.schemas

EXTRA_DIST =					\
	$(package_data_DATA)			\
	$(package_data_SCRIPTS)			\
	$(schema_DATA)				\
	gconf-1.0.dtd

TESTS = $(schema_DATA)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/applications
if GCONF_SCHEMAS_INSTALL
	GCONF_CONFIG_SOURCE=$(GCONF_SCHEMA_CONFIG_SOURCE) gconftool-2 --makefile-install-rule $(schemadir)/$(schema_DATA) >/dev/null
endif

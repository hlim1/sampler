EXTRA_DIST =					\
	interface.glade				\
	interface.gladep			\
	sampler.mk				\
	wrapper

if ENABLE_SAMPLER

launcher_DATA :=				\
	config					\
	interface.glade				\
	wrapper

schemadir := $(GCONF_SCHEMA_FILE_DIR)
schema_DATA := $(PACKAGE)-sampler.schemas

install-data-local:
	$(LN_S) $(SAMPLER_ICON) $(DESTDIR)$(launcherdir) icon.$(suffix $(SAMPLER_ICON))

uninstall-local:
	rm -f $(DESTDIR)$(launcherdir) icon.$(suffix $(SAMPLER_ICON))

install-data-hook:
	GCONF_CONFIG_SOURCE='$(GCONF_SCHEMA_CONFIG_SOURCE)' $(GCONFTOOL) --makefile-install-rule '$(schemadir)/$(schema_DATA)'

endif

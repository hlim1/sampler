SUBDIRS =					\
	evolution				\
	gaim					\
	gnumeric

DIST_SUBDIRS = $(SUBDIRS) gnumeric-non-gui

EXTRA_DIST =					\
	config.in				\
	gconf-1.0.dtd				\
	rules.mk				\
	wrapper.in

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/applications

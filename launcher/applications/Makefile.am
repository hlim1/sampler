SUBDIRS =					\
	gaim					\
	evolution

DIST_SUBDIRS = $(SUBDIRS) gnumeric-non-gui

EXTRA_DIST =					\
	config.in				\
	gconf-1.0.dtd				\
	rules.mk				\
	wrapper.in

srpm rpm: %: $(SUBDIRS:=/%)
.PHONY: srpm rpm

%/srpm %/rpm: force
	$(MAKE) -C $(@D) $(@F)
.PHONY: %/srpm %/rpm

force:
.PHONY: force

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/applications

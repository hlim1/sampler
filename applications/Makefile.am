SUBDIRS =					\
	gaim					\
	evolution				\
	nautilus

EXTRA_DIST =					\
	.rpmmacros				\
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

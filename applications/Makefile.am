if HAVE_XIMIAN_RPMS
SUBDIRS = nautilus
else
SUBDIRS =					\
	gaim					\
	gimp					\
	evolution
endif

EXTRA_DIST =					\
	.rpmmacros				\
	config.in				\
	gconf-1.0.dtd				\
	rules.mk				\
	sampler.schemas.in			\
	wrapper.in

srpm rpm: %: $(SUBDIRS:=/%)
.PHONY: srpm rpm

%/srpm %/rpm: force
	$(MAKE) -C $(@D) $(@F)
.PHONY: %/srpm %/rpm

force:
.PHONY: force

AUTOMAKE_OPTIONS = foreign 1.6

if WITH_GNOME
launcher = launcher
endif

SUBDIRS =					\
	debian					\
	doc					\
	fuzz					\
	instrumentor				\
	$(launcher)				\
	lib					\
	mining					\
	ocaml					\
	tools					\
	www


all-local: package.m4

install-data-local:
	mkdir $(DESTDIR)$(package_libdir)/sites
	mkdir $(DESTDIR)$(package_libdir)/wrapped
	mkdir $(DESTDIR)$(package_datadir)/applications

rpms: dist sampler.spec
	rm -rf redhat
	mkdir -p redhat/BUILD redhat/RPMS/$(RPM_ARCH) redhat/SOURCES redhat/SPECS redhat/SRPMS
	cp $(DIST_ARCHIVES) redhat/SOURCES
	cp sampler.spec redhat/SPECS
	rpmbuild --define '_topdir $(shell pwd)/redhat' -ba redhat/SPECS/sampler.spec

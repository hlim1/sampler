AUTOMAKE_OPTIONS = foreign 1.6
ACLOCAL_AMFLAGS = -I /usr/share/aclocal

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
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/sites
	$(mkinstalldirs) $(DESTDIR)$(package_libdir)/wrapped
	$(mkinstalldirs) $(DESTDIR)$(package_datadir)/applications

rpms: dist sampler.spec
	rm -rf redhat
	mkdir -p redhat/BUILD redhat/RPMS/$(DISTRO_ARCH) redhat/SOURCES redhat/SPECS redhat/SRPMS
	cp $(distdir).tar.gz redhat/SOURCES
	cp sampler.spec redhat/SPECS
	rpmbuild --define '_topdir $(shell pwd)/redhat' -ba redhat/SPECS/sampler.spec

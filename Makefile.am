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

EXTRA_DIST =					\
	$(PACKAGE).spec				\
	package.m4


all-local: package.m4

install-data-local:
	mkdir $(DESTDIR)$(package_libdir)/sites
	mkdir $(DESTDIR)$(package_libdir)/wrapped
	mkdir $(DESTDIR)$(package_datadir)/applications

rpms: dist
#	rpmbuild -D 'do_check 1' -ta $(distdir).tar.gz
	rpmbuild -ta $(distdir).tar.gz

AUTOMAKE_OPTIONS = foreign 1.6

SUBDIRS =					\
	doc					\
	fuzz					\
	instrumentor				\
	launcher				\
	lib					\
	tools					\
	www

DIST_SUBDIRS =					\
	$(SUBDIRS)				\
	debian

EXTRA_DIST =					\
	$(PACKAGE).spec				\
	package.m4


install-data-local:
	mkdir $(DESTDIR)$(package_libdir)/sites

rpms: dist
#	rpmbuild -D 'do_check 1' -ta $(distdir).tar.gz
	rpmbuild -ta $(distdir).tar.gz

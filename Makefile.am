AUTOMAKE_OPTIONS = foreign 1.6

SUBDIRS =					\
	doc					\
	fuzz					\
	instrumentor				\
	launcher				\
	lib					\
	tools

DIST_SUBDIRS =					\
	$(SUBDIRS)				\
	benchmarks				\
	debian

EXTRA_DIST =					\
	$(PACKAGE).spec				\
	package.m4


install-data-local:
	mkdir $(DESTDIR)$(package_libdir)/sites

rpms: dist
	rpmbuild -D 'do_check 1' -ta $(distdir).tar.gz

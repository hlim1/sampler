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
	benchmarks

EXTRA_DIST =					\
	$(PACKAGE).spec				\
	package.m4

srpm: dist
	rpmbuild -ta $(distdir).tar.gz

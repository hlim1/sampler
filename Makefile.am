AUTOMAKE_OPTIONS = foreign

libraries = libcountdown liblog
SUBDIRS = libcountdown liblog instrumentor

Makefile: libtool

libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck

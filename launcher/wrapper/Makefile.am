pixmap_links = enabled-16.png

wrapper_DATA = wrapper.glade

wrapper_PYTHON = $(sort $(wildcard *.py) Paths.py)

wrapper_SCRIPTS = wrapper

EXTRA_DIST =						\
	$(wrapper_DATA)					\
	$(filter-out Paths.py, $(wrapper_PYTHON))	\
	Paths.py.in					\
	wrapper.gladep					\
	wrapper.in

BUILT_SOURCES = wrapper Paths.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(wrapperdir)
	$(LN_S) $(pixmap_links:%=../pixmaps/%) $(DESTDIR)$(wrapperdir)

install-data-hook:
	rm -f $(wrapper_PYTHON:%=$(DESTDIR)$(wrapperdir)/%)
	rm -f $(wrapper_PYTHON:%.py=$(DESTDIR)$(wrapperdir)/%.pyc)

wrapper Paths.py: %: %.in Makefile
	sed						\
		-e 's!@''wrapperdir@!$(wrapperdir)!'	\
		-e 's!@''commondir@!$(commondir)!'	\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

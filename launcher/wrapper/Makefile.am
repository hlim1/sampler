wrapper_DATA = wrapper.glade

wrapper_PYTHON = $(sort $(wildcard *.py) Paths.py)

EXTRA_DIST =						\
	$(wrapper_DATA)					\
	$(filter-out Paths.py, $(wrapper_PYTHON))	\
	Paths.py.in					\
	wrapper.gladep

BUILT_SOURCES = Paths.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


install-data-hook:
	rm -f $(wrapper_PYTHON:%=$(DESTDIR)$(wrapperdir)/%)
	rm -f $(wrapper_PYTHON:%.py=$(DESTDIR)$(wrapperdir)/%.pyc)

Paths.py: %: %.in Makefile
	sed						\
		-e 's!@''wrapperdir@!$(wrapperdir)!'	\
		-e 's!@''commondir@!$(commondir)!'	\
		<$< >$@.tmp
	mv $@.tmp $@

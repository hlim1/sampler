common_PYTHON = $(sort $(wildcard *.py) Config.py)

EXTRA_DIST = $(wildcard *.py) Config.py.in

BUILT_SOURCES = Config.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


install-data-hook:
	rm -f $(common_PYTHON:%=$(DESTDIR)$(commondir)/%)
	rm -f $(common_PYTHON:%.py=$(DESTDIR)$(commondir)/%.pyc)


Config.py: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''pixmapsdir@!$(pixmapsdir)!'		\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

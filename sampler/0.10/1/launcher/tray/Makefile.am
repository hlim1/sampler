servers_DATA = Sampler_Monitor.server

tray_DATA = tray.glade

tray_PYTHON = $(sort $(wildcard *.py) Paths.py)

tray_SCRIPTS = tray

EXTRA_DIST =					\
	$(servers_DATA:=.in)			\
	$(tray_DATA)				\
	$(filter-out Paths.py, $(tray_PYTHON))	\
	Paths.py.in				\
	tray.gladep				\
	tray.in

BUILT_SOURCES =					\
	Paths.py				\
	Sampler_Monitor.server			\
	tray

MOSTLYCLEANFILES = *.pyc *.pyo oaf.dtd $(BUILT_SOURCES)

TESTS = $(servers_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(tray_PYTHON:%=$(DESTDIR)$(traydir)/%)
	rm -f $(tray_PYTHON:%.py=$(DESTDIR)$(traydir)/%.pyc)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''traydir@!$(traydir)!'			\
		-e 's!@''traylibdir@!$(traylibdir)!'		\
		<$< >$@
	chmod a+x $@


check-am: oaf.dtd

oaf.dtd: %: ../%
	$(LN_S) $< $@

.DELETE_ON_ERROR:

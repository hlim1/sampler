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

BUILT_SOURCES = tray Paths.py Sampler_Monitor.server

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(servers_DATA)
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


install-data-hook:
	rm -f $(tray_PYTHON:%=$(DESTDIR)$(traydir)/%)
	rm -f $(tray_PYTHON:%.py=$(DESTDIR)$(traydir)/%.pyc)


tray Paths.py Sampler_Monitor.server: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''traydir@!$(traydir)!'			\
		-e 's!@''traylibdir@!$(traylibdir)!'		\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

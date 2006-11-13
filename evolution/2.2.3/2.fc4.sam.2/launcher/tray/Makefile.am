servers_DATA = Sampler_Monitor.server

tray_DATA = tray.glade

nodist_tray_PYTHON = Paths.py
tray_PYTHON =					\
	AboutDialog.py				\
	BusyCursor.py				\
	Factory.py				\
	LazyDialog.py				\
	LazyWidget.py				\
	Main.py					\
	PopupMenu.py				\
	PreferencesDialog.py			\
	UploaderTrayIcon.py

all_python = $(nodist_tray_PYTHON) $(tray_PYTHON)

tray_SCRIPTS = tray

EXTRA_DIST =					\
	$(servers_DATA:=.in)			\
	$(tray_DATA)				\
	$(tray_PYTHON)				\
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
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.pyc)


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

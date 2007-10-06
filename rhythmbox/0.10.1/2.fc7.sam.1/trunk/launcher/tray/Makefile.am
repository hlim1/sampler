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

link_python =					\
	BlipIcons.py				\
	GConfDir.py				\
	GConfNotifier.py			\
	Keys.py					\
	MasterNotifier.py			\
	SamplerConfig.py			\
	Signals.py				\
	StatusIcon.py

tray_SCRIPTS = tray

EXTRA_DIST =					\
	$(servers_DATA:=.in)			\
	$(tray_DATA)				\
	$(tray_PYTHON)				\
	Paths.py.in				\
	activate				\
	oaf.dtd					\
	tray.gladep				\
	tray.in

BUILT_SOURCES =					\
	Paths.py				\
	Sampler_Monitor.server			\
	tray

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(all_python) $(servers_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(traydir)/%.pyc)


dist-hook:
	cp -pd $(link_python) $(distdir)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''traydir@!$(traydir)!'			\
		-e 's!@''traylibdir@!$(traylibdir)!'		\
		<$< >$@
	if [ -x $< ]; then chmod +x $@; fi


.DELETE_ON_ERROR:

pixmap_links = 					\
	disabled-16.png				\
	disabled-32.png				\
	disabled-48.png				\
	enabled-16.png				\
	enabled-32.png				\
	enabled-48.png

servers_DATA = Sampler_Monitor.server

tray_DATA = tray.glade

tray_PYTHON = $(sort $(wildcard *.py) Paths.py)

tray_SCRIPTS = tray

EXTRA_DIST =					\
	$(tray_DATA)				\
	$(filter-out Paths.py, $(tray_PYTHON))	\
	Paths.py.in				\
	tray.gladep				\
	tray.in

BUILT_SOURCES = tray Paths.py Sampler_Monitor.server

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(traydir)
	$(LN_S) $(pixmap_links:%=../pixmaps/%) $(DESTDIR)$(traydir)

install-data-hook:
	rm -f $(tray_PYTHON:%=$(DESTDIR)$(traydir)/%)
	rm -f $(tray_PYTHON:%.py=$(DESTDIR)$(traydir)/%.pyc)


tray Paths.py Sampler_Monitor.server: %: %.in Makefile
	sed						\
		-e 's!@''traydir@!$(traydir)!'		\
		-e 's!@''commondir@!$(commondir)!'	\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

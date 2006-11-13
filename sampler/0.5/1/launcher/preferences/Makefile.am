servers_DATA = Sampler_Preferences.server

preferences_DATA = preferences.glade

preferences_PYTHON = $(sort $(wildcard *.py) Paths.py)

preferences_SCRIPTS = preferences

bin_SCRIPTS = sampler-preferences

cappletdir = ${datadir}/control-center-2.0/capplets
capplet_DATA = sampler-preferences.desktop

EXTRA_DIST =						\
	$(capplet_DATA)					\
	$(preferences_DATA)				\
	$(servers_DATA:=.in)				\
	$(filter-out Paths.py, $(preferences_PYTHON))	\
	Paths.py.in					\
	preferences.gladep				\
	preferences.in					\
	sampler-preferences.in

BUILT_SOURCES =					\
	Paths.py				\
	Sampler_Preferences.server		\
	preferences				\
	sampler-preferences

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(capplet_DATA)
TESTS_ENVIRONMENT = desktop-file-validate


install-data-hook:
	rm -f $(preferences_PYTHON:%=$(DESTDIR)$(preferencesdir)/%)
	rm -f $(preferences_PYTHON:%.py=$(DESTDIR)$(preferencesdir)/%.pyc)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''preferencesdir@!$(preferencesdir)!'	\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

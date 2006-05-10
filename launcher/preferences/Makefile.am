servers_DATA = Sampler_Preferences.server

preferences_DATA = preferences.glade

nodist_preferences_PYTHON = Paths.py
preferences_PYTHON =				\
	AppFinder.py				\
	Application.py				\
	AppModel.py				\
	Factory.py				\
	Main.py					\
	PreferencesDialog.py

all_python = $(nodist_preferences_PYTHON) $(preferences_PYTHON)
link_python = Keys.py


preferences_SCRIPTS = preferences

bin_SCRIPTS = sampler-preferences

applicationsdir = ${datadir}/applications
applications_DATA = sampler-preferences.desktop

EXTRA_DIST =					\
	$(applications_DATA)			\
	$(preferences_DATA)			\
	$(preferences_PYTHON)			\
	$(servers_DATA:=.in)			\
	Paths.py.in				\
	preferences.gladep			\
	preferences.in				\
	sampler-preferences.in

BUILT_SOURCES =					\
	Paths.py				\
	Sampler_Preferences.server		\
	preferences				\
	sampler-preferences

MOSTLYCLEANFILES = *.pyc *.pyo oaf.dtd $(link_python) $(BUILT_SOURCES)

TESTS = $(applications_DATA) $(servers_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(preferencesdir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(preferencesdir)/%.pyc)


Paths.py Sampler_Preferences.server: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''preferencesdir@!$(preferencesdir)!'	\
		<$< >$@

preferences sampler-preferences: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''preferencesdir@!$(preferencesdir)!'	\
		<$< >$@
	chmod a+x $@


check-am: oaf.dtd

oaf.dtd: %: ../%
	$(LN_S) $< $@

check-local: $(all_python) $(link_python)
	pychecker $(all_python)

$(link_python): %: ../common/%
	$(LN_S) $< $@


.DELETE_ON_ERROR:

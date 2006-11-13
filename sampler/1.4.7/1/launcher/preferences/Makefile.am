preferences_DATA = preferences.glade

nodist_preferences_PYTHON = Paths.py
preferences_PYTHON =				\
	AppFinder.py				\
	Application.py				\
	AppModel.py				\
	Main.py					\
	PreferencesDialog.py

all_python = $(nodist_preferences_PYTHON) $(preferences_PYTHON)
link_python = Keys.py


bin_SCRIPTS = sampler-preferences

applicationsdir = ${datadir}/applications
applications_DATA = sampler-preferences.desktop

EXTRA_DIST =					\
	$(applications_DATA)			\
	$(preferences_DATA)			\
	$(preferences_PYTHON)			\
	Paths.py.in				\
	preferences.gladep			\
	sampler-preferences.in

BUILT_SOURCES =					\
	Paths.py				\
	sampler-preferences

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

TESTS = $(all_python) $(applications_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(preferencesdir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(preferencesdir)/%.pyc)


dist-hook:
	cp -pd $(link_python) $(distdir)


Paths.py: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''bindir@!$(bindir)!'			\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''preferencesdir@!$(preferencesdir)!'	\
		<$< >$@

sampler-preferences: %: %.in Makefile
	sed							\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''preferencesdir@!$(preferencesdir)!'	\
		<$< >$@
	chmod a+x $@


.DELETE_ON_ERROR:

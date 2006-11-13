first_time_DATA = first-time.glade

nodist_first_time_PYTHON = Paths.py
first_time_PYTHON =				\
	FirstTime.py				\
	Main.py

all_python = $(nodist_first_time_PYTHON) $(first_time_PYTHON)
link_python = GConfDir.py Keys.py SamplerConfig.py

first_time_SCRIPTS = first-time

EXTRA_DIST =					\
	$(first_time_DATA)			\
	$(first_time_PYTHON)			\
	Paths.py.in				\
	first-time.gladep			\
	first-time.in

BUILT_SOURCES =					\
	Paths.py				\
	first-time

MOSTLYCLEANFILES = *.pyc *.pyo $(link_python) $(BUILT_SOURCES)

TESTS = $(all_python)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(first_timedir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(first_timedir)/%.pyc)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''commondir@!$(commondir)!'		\
		<$< >$@
	chmod a+x $@


check-am: $(link_python)

$(link_python): %: ../common/%
	$(LN_S) $< $@


.DELETE_ON_ERROR:

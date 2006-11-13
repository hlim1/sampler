servers_DATA = Sampler_FirstTime.server

first_time_DATA = first-time.glade

first_time_PYTHON = $(sort $(wildcard *.py) Paths.py)

first_time_SCRIPTS = first-time

EXTRA_DIST =						\
	$(servers_DATA:=.in)				\
	$(first_time_DATA)				\
	$(filter-out Paths.py, $(first_time_PYTHON))	\
	Paths.py.in					\
	first-time.gladep				\
	first-time.in

BUILT_SOURCES =					\
	Paths.py				\
	Sampler_FirstTime.server		\
	first-time

MOSTLYCLEANFILES = *.pyc *.pyo oaf.dtd $(BUILT_SOURCES)

TESTS = $(servers_DATA)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(first_time_PYTHON:%=$(DESTDIR)$(first_timedir)/%)
	rm -f $(first_time_PYTHON:%.py=$(DESTDIR)$(first_timedir)/%.pyc)


$(BUILT_SOURCES): %: %.in Makefile
	sed							\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''commondir@!$(commondir)!'		\
		<$< >$@
	chmod a+x $@


check-am: oaf.dtd

oaf.dtd: %: ../%
	$(LN_S) $< $@

.DELETE_ON_ERROR:

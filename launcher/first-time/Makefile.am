pixmap_links = 					\
	disabled-16.png				\
	disabled-48.png				\
	enabled-16.png				\
	enabled-48.png

first_time_DATA = first-time.glade

first_time_PYTHON =				\
	FirstTime.py				\
	Paths.py

first_time_SCRIPTS = first-time

EXTRA_DIST =					\
	$(first_time_DATA)			\
	FirstTime.py				\
	Paths.py.in				\
	first-time.gladep			\
	first-time.in

BUILT_SOURCES = first-time Paths.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(first_timedir)
	$(LN_S) $(pixmap_links:%=../pixmaps/%) $(DESTDIR)$(first_timedir)

install-data-hook:
	rm -f $(first_time_PYTHON:%=$(DESTDIR)$(first_timedir)/%)
	rm -f $(first_time_PYTHON:%.py=$(DESTDIR)$(first_timedir)/%.pyc)

first-time Paths.py: %: %.in Makefile
	sed							\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''commondir@!$(commondir)!'		\
		<$< >$@.tmp
	chmod a+x $@.tmp
	mv $@.tmp $@

nodist_common_PYTHON = Config.py
common_PYTHON =					\
	BlipIcons.py				\
	GConfDir.py				\
	GConfNotifier.py			\
	Keys.py					\
	LazyIcon.py				\
	MasterNotifier.py			\
	Signals.py				\
	StatusIcon.py				\
	WindowIcon.py

all_python = $(nodist_common_PYTHON) $(common_PYTHON)

EXTRA_DIST = $(common_PYTHON) Config.py.in

BUILT_SOURCES = Config.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(commondir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(commondir)/%.pyc)


Config.py: %: %.in Makefile
	sed							\
		-e 's!@''VERSION@!$(VERSION)!'			\
		-e 's!@''pixmapsdir@!$(pixmapsdir)!'		\
		<$< >$@
	chmod a+x $@

.DELETE_ON_ERROR:

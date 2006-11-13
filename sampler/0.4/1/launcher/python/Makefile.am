launcher_PYTHON := $(wildcard *.py)
EXTRA_DIST = $(launcher_PYTHON)
MOSTLYCLEANFILES = *.pyc *.pyo

install-data-hook:
	rm -f $(launcher_PYTHON:%=$(DESTDIR)$(launcherdir)/%)

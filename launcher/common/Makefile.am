common_PYTHON = $(sort $(wildcard *.py) Config.py)

EXTRA_DIST = $(wildcard *.py)

MOSTLYCLEANFILES = *.pyc *.pyo

install-data-hook:
	rm -f $(common_PYTHON:%=$(DESTDIR)$(commondir)/%)
	rm -f $(common_PYTHON:%.py=$(DESTDIR)$(commondir)/%.pyc)

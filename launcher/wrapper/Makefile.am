wrapper_DATA = wrapper.glade

nodist_wrapper_PYTHON = Paths.py
wrapper_PYTHON =				\
	AppConfig.py				\
	Launcher.py				\
	Main.py					\
	Outcome.py				\
	RedirectHandler.py			\
	ReportsReader.py			\
	SampledLauncher.py			\
	ServerMessage.py			\
	UnsampledLauncher.py			\
	Uploader.py				\
	Upload.py				\
	UserConfig.py

all_python = $(nodist_wrapper_PYTHON) $(wrapper_PYTHON)

EXTRA_DIST =					\
	$(wrapper_DATA)				\
	$(wrapper_PYTHON)			\
	Paths.py.in				\
	wrapper.gladep

BUILT_SOURCES = Paths.py

MOSTLYCLEANFILES = *.pyc *.pyo $(BUILT_SOURCES)


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.pyc)

Paths.py: %: %.in Makefile
	sed						\
		-e 's!@''wrapperdir@!$(wrapperdir)!'	\
		-e 's!@''commondir@!$(commondir)!'	\
		<$< >$@

.DELETE_ON_ERROR:

wrapper_DATA = wrapper.glade

nodist_wrapper_PYTHON = Paths.py
wrapper_PYTHON =				\
	Activation.py				\
	AppConfig.py				\
	Launcher.py				\
	Main.py					\
	Main2.py				\
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
link_python = Keys.py

EXTRA_DIST =					\
	$(wrapper_DATA)				\
	$(wrapper_PYTHON)			\
	Paths.py.in				\
	wrapper.gladep

BUILT_SOURCES = Paths.py

MOSTLYCLEANFILES = *.pyc *.pyo $(link_python) $(BUILT_SOURCES)

TESTS = $(all_python)
TESTS_ENVIRONMENT = ../test-by-extension


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.pyc)

Paths.py: %: %.in Makefile
	sed							\
		-e 's!@''commondir@!$(commondir)!'		\
		-e 's!@''first_timedir@!$(first_timedir)!'	\
		-e 's!@''wrapperdir@!$(wrapperdir)!'		\
		<$< >$@


check-am: $(link_python)

$(link_python): %: ../common/%
	$(LN_S) $< $@


.DELETE_ON_ERROR:

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


install-data-hook:
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.py)
	rm -f $(all_python:%.py=$(DESTDIR)$(wrapperdir)/%.pyc)

Paths.py: %: %.in Makefile
	sed						\
		-e 's!@''wrapperdir@!$(wrapperdir)!'	\
		-e 's!@''commondir@!$(commondir)!'	\
		<$< >$@


check-local: $(all_python) $(link_python)
	pychecker $(all_python)

$(link_python): %: ../common/%
	$(LN_S) $< $@



.DELETE_ON_ERROR:

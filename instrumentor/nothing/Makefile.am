EXTRA_DIST =					\
	cfg.c					\
	cfg.expected				\
	last-switch.c				\
	library.c				\
	library.h				\
	main.c					\
	plugin.c				\
	pipes.c					\
	testsuite.at

TESTSUITE = $(srcdir)/testsuite
check_SCRIPTS = $(TESTSUITE)
check-local: atconfig $(TESTSUITE)
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_builddir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@

CLEANFILES = atconfig
clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean
	rm -f $(TESTSUITE)

.DELETE_ON_ERROR:

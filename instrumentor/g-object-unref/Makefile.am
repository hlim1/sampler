EXTRA_DIST =					\
	test.c					\
	test.expected				\
	testsuite				\
	testsuite.at

TESTSUITE = $(srcdir)/testsuite
check_SCRIPTS = $(TESTSUITE)
check-local: atconfig atlocal
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_srcdir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@

CLEANFILES = atconfig
clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean

.DELETE_ON_ERROR:

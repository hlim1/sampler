EXTRA_DIST =					\
	first.expected				\
	last.expected				\
	simple.c

TESTSUITE = $(srcdir)/testsuite
check_SCRIPTS = $(TESTSUITE)
check-local: atconfig
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_srcdir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@

clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean

.DELETE_ON_ERROR:

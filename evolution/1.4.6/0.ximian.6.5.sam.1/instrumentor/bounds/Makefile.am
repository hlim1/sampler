EXTRA_DIST =					\
	enum.c					\
	enum.expected				\
	testsuite				\
	testsuite.at

TESTSUITE = $(srcdir)/testsuite
check-local: atconfig $(TESTSUITE)
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_srcdir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@.tmp
	mv $@.tmp $@

clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean

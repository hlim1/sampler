EXTRA_DIST =					\
	extern-callee.c				\
	extern-caller.c				\
	extern.expected				\
	test.c					\
	test.expected				\
	testsuite				\
	testsuite.at

TESTSUITE = $(srcdir)/testsuite
check-local: atconfig $(TESTSUITE)
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@.tmp
	mv $@.tmp $@

clean-local:
	$(TESTSUITE) --clean

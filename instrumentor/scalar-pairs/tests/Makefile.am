EXTRA_DIST =					\
	late-global.c				\
	late-global.expected			\
	testsuite				\
	testsuite.at				\
	upcase-bad.c				\
	upcase-bad.expected			\
	upcase-good.c				\
	upcase-good.expected

TESTSUITE = $(srcdir)/testsuite
check-local: atconfig $(TESTSUITE)
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_srcdir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@.tmp
	mv $@.tmp $@

clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean

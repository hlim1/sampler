EXTRA_DIST =					\
	library.c				\
	library.h				\
	main.c					\
	plugin.c				\
	testsuite.at				\
	testsuite

TESTSUITE = $(srcdir)/testsuite
check_SCRIPTS = $(TESTSUITE)
check-local: atconfig
	$(SHELL) $(TESTSUITE)

AUTOTEST = autom4te --language=autotest
$(TESTSUITE): $(srcdir)/testsuite.at $(top_srcdir)/package.m4
	$(AUTOTEST) -I $(top_srcdir) -I $(srcdir) $@.at -o $@

CLEANFILES = atconfig
clean-local: $(TESTSUITE)
	$(TESTSUITE) --clean

.DELETE_ON_ERROR:

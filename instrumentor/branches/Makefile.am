EXTRA_DIST =					\
	modular-a.c				\
	modular-b.c				\
	modular.expected			\
	library.c				\
	library.h				\
	plugin.c				\
	sharing.c				\
	sharing.expected			\
	simple.c				\
	simple.expected				\
	threads.c				\
	threads.expected			\
	testsuite				\
	testsuite.at

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

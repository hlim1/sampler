EXTRA_DIST =					\
	default.c				\
	goto-bottom.c				\
	goto-middle.c				\
	goto-top-post.c				\
	goto-top-pre.c				\
	if-both.c				\
	if-else.c				\
	if-then.c				\
	no-default.c				\
	testsuite				\
	testsuite.at				\
	work.h

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

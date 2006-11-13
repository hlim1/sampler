AM_CPPFLAGS = -W -Wall -Werror

noinst_PROGRAMS = modernize
modernize_SOURCES = modernize.ll

EXTRA_DIST = stamps.pl

-include stamps.mk

overview.xml: $(stamps)
	find results/*/*/preds.txt -size +0 | ./overview.pl >$@
	xmllint --valid --noout $@

stamps.mk: stamps.pl
	./$< >$@

CLEANFILES = stamps.mk
clean-local:
	rm overview.xml
	rm -rf results

.DELETE_ON_ERROR:

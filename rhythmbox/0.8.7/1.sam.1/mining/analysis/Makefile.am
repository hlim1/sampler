AM_CPPFLAGS = -W -Wall -Werror

noinst_PROGRAMS = modernize
modernize_SOURCES = modernize.ll

EXTRA_DIST = stamps.pl

-include stamps.mk

stamps: $(sort $(stamps))
.PHONY: stamps

results/stamp:
	mkdir $(@D)
	touch $@

stamps.mk: stamps.pl
	./$< >$@

CLEANFILES = stamps.mk
clean-local:
	rm -rf results

.DELETE_ON_ERROR:

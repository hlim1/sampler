AM_CPPFLAGS = -W -Wall -Werror

noinst_PROGRAMS = modernize
modernize_SOURCES = modernize.ll

-include stamps.mk

stamps: $(sort $(stamps))
.PHONY: stamps

results/stamp:
	mkdir $(@D)
	touch $@

stamps.mk: stamps.pl
	./$< >$@

clean-local:
	rm -rf results

.DELETE_ON_ERROR:

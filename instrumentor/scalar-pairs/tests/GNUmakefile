tests := late-global upcase-good upcase-bad

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) --$(cyclic)
CFLAGS := -g -W -Wall -Werror

objects := $(tests:=.o)
traces := $(tests:=.trace)
reports := $(tests:=.report)
passed := $(tests:=.passed)

countdir := $(top)/../libcountdown
reportdir := $(top)/../libreport
lib := ../libscalar-pairs/libscalar-pairs.la $(countdir)/lib$(cyclic).la $(countdir)/libcountdown.la $(reportdir)/libreport.la

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(passed)
.PHONY: check

$(passed): %.passed: %.expected %.report
	cmp $^
	touch $@

$(reports): %.report: $(top)/../resolver/resolve-samples % %.trace
	$< $* <$*.trace >$@.
	mv $@. $@

upcase-bad.trace: %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$< once upon a time || :
	[ -r $@ ]

upcase-good.trace: %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$< once upon a time
	[ -r $@ ]

late-global.trace: late-global $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
	[ -r $@ ]

$(tests): %: %.o $(lib)

$(objects): %.o: %.c $(front_end) ../main ../libscalar-pairs/scalar-pairs.h ../libscalar-pairs/scalar-pairs-cil.h $(countdir)/$(cyclic).h $(reportdir)/requires.h $(reportdir)/report.h

../main: $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	libtool --mode=clean 'rm -f' $(tests)
	rm -f $(passed) $(reports) $(reports:=.) $(traces) *.[ios] *.inst.c
.PHONY: clean

spotless: clean
.PHONY: spotless

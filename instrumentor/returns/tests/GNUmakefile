tests := test extern

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) --$(cyclic)
CFLAGS := -g -W -Wall -Werror -save-temps

traces := $(tests:=.trace)
reports := $(tests:=.report)

countdir := $(top)/../libcountdown
lib := ../libreturns/libreturns.la $(countdir)/lib$(cyclic).la $(countdir)/libcountdown.la

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(reports)
.PHONY: check

$(reports): %.report: $(top)/../resolver/resolve-samples % %.trace
	$< $* <$*.trace >$@.
	mv $@. $@

$(traces): %.trace: %
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
	[ -r $@ ]

test: test.o $(lib) ../main
	$(LINK.o) $< $(LOADLIBES) $(LDLIBS) -o $@

extern: extern-caller.o extern-callee.o $(lib) ../main
	$(LINK.o) extern-caller.o extern-callee.o $(LOADLIBES) $(LDLIBS) -o $@

test.o extern-caller.o extern-callee.o: %.o: %.c $(front_end) ../main ../libreturns/returns.h ../libreturns/returns-cil.h

../main: $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	libtool --mode=clean 'rm -f' $(tests)
	rm -f $(reports) $(reports:=.) $(traces) *.[ios] *.inst.c
.PHONY: clean

spotless: clean
.PHONY: spotless

tests := simple modular

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) --$(cyclic)
CFLAGS := -g -W -Wall -Werror

traces := $(tests:=.trace)
reports := $(tests:=.report)

countdir := $(top)/../libcountdown
lib := ../libbranches/libbranches.la $(countdir)/lib$(cyclic).la $(countdir)/libcountdown.la

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

simple: %: %.o $(lib) ../main
	$(LINK.o) $< $(LOADLIBES) $(LDLIBS) -o $@

modular: %: %-a.o %-b.o $(lib) ../main
	$(LINK.o) $*-a.o $*-b.o $(LOADLIBES) $(LDLIBS) -o $@

simple.o modular-a.o modular-b.o: %.o: %.c $(front_end) ../main ../libbranches/branches.h ../libbranches/branches-cil.h $(countdir)/$(cyclic).h

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

tests := simple

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) -g -W -Wall -Werror --$(cyclic)

traces := $(tests:=.trace)
checks := $(tests:=.check)

countdir := $(top)/../libcountdown
lib := ../libbranches/libbranches.la $(countdir)/lib$(cyclic).la $(countdir)/libcountdown.la

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(checks)
.PHONY: check

$(checks): %.check: %.trace
	[ -s $< ]
.PHONY: $(checks)

$(tests:=.trace): %.trace: %
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
	[ -r $@ ]

simple: %: %.o $(lib) ../main
	$(LINK.o) $< $(LOADLIBES) $(LDLIBS) -o $@

simple.o: %.o: %.c $(front_end) ../main ../libbranches/branches.h $(countdir)/$(cyclic).h

../main: $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(traces) $(tests) *.[ios] *.inst.c
.PHONY: clean

spotless: clean
.PHONY: spotless

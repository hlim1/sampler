tests := simple modular

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) --$(cyclic)
CFLAGS := -g -W -Wall -Werror -save-temps

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

$(checks): %.check: %.trace %.sites
	[ -s $< ]
.PHONY: $(checks)

$(tests:=.trace): %.trace: %
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
	[ -r $@ ]

$(tests:=.sites): %.sites: %
	$(top)/../resolver/extract-site-info $< >$@.
	mv $@. $@

simple: %: %.o $(lib) ../main
	$(LINK.o) $< $(LOADLIBES) $(LDLIBS) -o $@

modular: %: %-a.o %-b.o $(lib) ../main
	$(LINK.o) $*-a.o $*-b.o $(LOADLIBES) $(LDLIBS) -o $@

simple.o: %.o: %.c $(front_end) ../main ../libbranches/branches.h $(countdir)/$(cyclic).h

../main: $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	libtool --mode=clean 'rm -f' $(tests)
	rm -f $(traces) *.[ios] *.inst.c *.sites *.sites.
.PHONY: clean

spotless: clean
.PHONY: spotless

tests := test extern

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror

traces := $(tests:=.trace)
checks := $(tests:=.check)

countdir := $(top)/../libcountdown
lib := ../../libdaikount/libdaikount.la $(countdir)/libacyclic.la

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

test: test.o $(lib) ../main
	$(LINK.o) $< $(LOADLIBES) $(LDLIBS) -o $@

extern: extern-caller.o extern-callee.o $(lib) ../main
	$(LINK.o) extern-caller.o extern-callee.o $(LOADLIBES) $(LDLIBS) -o $@

test.o extern-caller.o extern-callee.o: %.o: %.c $(front_end) ../main ../../libdaikount/daikount.h

../main: $(force)
	$(recurse)

$(countdowns): $(force)
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

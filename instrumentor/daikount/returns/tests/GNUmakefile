tests := test extern

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror -save-temps

objects := $(tests:=.o)
traces := $(tests:=.trace)
checks := $(tests:=.check)

countdir := $(top)/../libcountdown
countdowns := $(countdir)/countdown-1-1
lib := ../../libdaikount/libdaikount.la $(countdir)/libevent.la $(countdir)/libcyclic.la

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

$(tests:=.trace): %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_EVENT_COUNTDOWNS=$(countdowns) ./$<
	[ -r $@ ]

test: test.o $(lib)

extern: extern-caller.o extern-callee.o $(lib)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

$(objects): %.o: %.c $(front_end) ../main ../../libdaikount/daikount.h

../main: $(force)
	$(recurse)

$(countdowns): $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(traces) $(tests) $(objects) $(tests:=.inst.c) $(tests:=.i) $(tests:=.inst.i) $(tests:=.inst.s)
.PHONY: clean

spotless: clean
.PHONY: spotless

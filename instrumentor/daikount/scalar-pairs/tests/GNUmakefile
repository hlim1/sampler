tests := late-global upcase-good upcase-bad

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror

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

upcase-bad.trace: %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_EVENT_COUNTDOWNS=$(countdowns) ./$< once upon a time || :
	[ -r $@ ]

upcase-good.trace: %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_EVENT_COUNTDOWNS=$(countdowns) ./$< once upon a time
	[ -r $@ ]

late-global.trace: late-global $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_EVENT_COUNTDOWNS=$(countdowns) ./$<
	[ -r $@ ]

$(tests): %: %.o $(lib)

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
	rm -f $(tests) *.[iso] *.inst.c
.PHONY: clean

spotless: clean
.PHONY: spotless

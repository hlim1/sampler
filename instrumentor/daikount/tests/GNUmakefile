tests := late-global upcase-good upcase-bad

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror -save-temps

objects := $(tests:=.o)
traces := $(tests:=.trace)
checks := $(tests:=.check)

countdowns := $(top)/libcountdown/countdown-1-1
lib := ../libdaikount/libdaikount.la

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

$(objects): %.o: %.c $(front_end) ../main

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

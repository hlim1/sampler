tests := upcase

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror -save-temps

traces := $(tests:=.trace)
objects := $(tests:=.o)

countdowns := $(top)/libcountdown/countdown-1-1

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(traces)
.PHONY: check

upcase.trace: upcase $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_COUNTDOWNS=$(countdowns) ./$< once upon a time || :
	[ -r $@ ]

$(objects): %.o: %.c $(front_end) ../main

../main: $(force)
	$(recurse)

$(countdowns): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(traces) $(tests) $(objects) $(tests:=.inst.c) $(tests:=.i) $(tests:=.inst.i) $(tests:=.inst.s)
.PHONY: clean

spotless: clean
.PHONY: spotless

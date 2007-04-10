tests := late-global upcase

top := ../../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror

traces := $(tests:=.trace)
objects := $(tests:=.o)

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(traces)
.PHONY: check

upcase.trace: upcase $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$< once upon a time || :
	[ -r $@ ]

late-global.trace: late-global $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
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

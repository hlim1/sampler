ifndef tests
$(error must define $$(tests))
endif

top := ../../../..

front_end := ../../driver/main ../main
CC := $(front_end) -g -W -Wall -Werror -save-temps

decodes := $(tests:=.decode)
traces := $(tests:=.trace)
objects := $(tests:=.o)

countdowns := $(top)/libcountdown/countdown-1-1
decoder := $(top)/liblog/print-trace

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(decodes)
.PHONY: check

$(decodes): %.decode: %.trace $(decoder)
	$(decoder) <$< >$@
	cat $@

$(traces): %.trace: % $(countdowns)
	SAMPLER_FILE=$@ SAMPLER_COUNTDOWNS=$(countdowns) ./$<
	[ -r $@ ]

$(objects): %.o: %.c $(top)/liblog/log.h $(top)/libcountdown/event.h $(front_end)

../main: $(force)
	$(recurse)

$(countdowns): $(force)
	$(recurse)

$(decoder): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(decodes) $(traces) $(tests) $(objects) $(tests:=.inst.c) $(tests:=.i) $(tests:=.inst.i) $(tests:=.inst.s)
.PHONY: clean

spotless: clean
.PHONY: spotless

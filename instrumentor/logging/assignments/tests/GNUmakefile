top := ../../../..

CC := $(top)/instrumentor/front-end ../main $(CC)
CFLAGS := -g -W -Wall -Werror -save-temps

tests := test

decodes := $(tests:=.decode)
traces := $(tests:=.trace)
objects := $(tests:=.o)

decoder := $(top)/liblog/print-trace

recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(decodes)
.PHONY: check

$(decodes): %.decode: %.trace $(decoder)
	$(decoder) <$< >$@
	cat $@

$(traces): %.trace: %
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<

$(objects): %.o: %.c $(top)/liblog/log.h $(top)/libcountdown/countdown.h ../main

../main: force
	$(recurse)

$(decoder): force
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(decodes) $(traces) $(tests) $(objects) $(tests:=.inst.c) $(tests:=.i) $(tests:=.inst.i) $(tests:=.inst.s)
.PHONY: clean

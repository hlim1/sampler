CC := ../../front-end ../main $(CC)

tests := 					\
	array					\
	conditional				\
	deep-pointers				\
	loop					\
	multiple				\
	return					\
	structures

decodes := $(addprefix decode-, $(tests))
traces := $(tests:=.trace)
objects := $(tests:=.o)

decoder := ../../liblog/decoder

recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all: $(decodes)
.PHONY: all

$(decodes): decode-%: %.trace $(decoder)
	$(decoder) <$<
.PHONY: $(decodes)

$(traces): %.trace: %
	./$< 2>$@.
	mv $@. $@

$(objects): %.o: %.c ../../liblog/log.h ../../libcountdown/countdown.h ../main

../main: force
	$(recurse)

$(decoder): force
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(traces) $(traces:=.) $(tests) $(objects) $(tests:=.inst.c) $(tests:=.i)
.PHONY: clean

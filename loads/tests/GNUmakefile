CC := ../front-end $(CC)

tests := 					\
	array					\
	conditional				\
	deep-pointers				\
	multiple				\
	return					\
	structures

runs := $(addprefix run-, $(tests))
objects := $(tests:=.o)

all: $(runs)
.PHONY: all

$(runs): run-%: %
	./$^
.PHONY: $(runs)

$(objects): %.o: %.c ../liblog/log.h ../../libcountdown/countdown.h ../main

../main: force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean:
	rm -f $(tests) $(objects)
.PHONY: clean

prologue := ../liblog/log.h
CPPFLAGS := -include $(prologue)

all: run
.PHONY: all

run: test.inst
	./$^
.PHONY: run

test.inst.c: ../main test.i
	$^ >$@

%.i: %.c $(prologue)
	$(CPP) $(CPPFLAGS) $< >$@

../main: force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

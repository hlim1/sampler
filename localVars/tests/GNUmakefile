CPPFLAGS := -include ../liblog/log.h

all: run
.PHONY: all

run: ../main test.i
	$^
.PHONY: run

%.i: %.c
	$(CPP) $(CPPFLAGS) $< >$@

../main: force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

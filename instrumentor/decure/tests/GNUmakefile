cildir := ../../cil
link = $(LINK.c) $(filter-out ../main, $^) $(LOADLIBES) $(LDLIBS) -o $@

tests := echo static crasher
force := force

all:
.PHONY: all

check: $(tests:=-cured) $(tests:=-decured)
.PHONY: check

%-cured: CC := $(cildir)/bin/ccured
%-decured: CC := ../driver/main

echo-cured echo-decured: echo.c main.c ../main
	$(link)

crasher-cured crasher-decured: crasher.c ../main
	$(link)

static-cured static-decured: static-1.c static-2.c static-main.c ../main
	$(link)

../main: $(force)
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean:
	rm -f *-cured *cured.c
	rm -f *-decured *-decured.c
	rm -f *_inst.c
	rm -f  *.[ios]
	rm -rf .libs
.PHONY: clean

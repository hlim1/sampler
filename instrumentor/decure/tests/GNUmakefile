cildir := ../../../../cil
link = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

all:
.PHONY: all

check: echo-cured echo-decured
.PHONY: check

%-cured: CC := $(cildir)/bin/ccured
%-decured: CC := ../driver/main

echo-cured echo-decured: echo.c main.c
	$(link)

crasher-cured crasher-decured: crasher.c
	$(link)

force:
.PHONY: force

clean:
	rm -f *-cured *cured.c
	rm -f *-decured *-decured.c
	rm -f *_inst.c
	rm -f  *.[ios]
.PHONY: clean

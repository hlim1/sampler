cildir := ../../../../cil

check: echo-cured echo-decured

%-cured: CC := $(cildir)/bin/ccured
%-decured: CC := ../driver/main

echo-cured: echo.c main.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

echo-decured: echo.c main.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

force:
.PHONY: force

clean:
	rm -f *-cured *cured.c
	rm -f *-decured *-decured.c
	rm -f *.inst.c
	rm -f  *.[ios]
.PHONY: clean

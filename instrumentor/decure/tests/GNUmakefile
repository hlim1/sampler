cildir := ../../../../cil

#CFLAGS := -W -Wall -Werror

all: echo-cured echo-decured

%-cured: CC := $(cildir)/bin/ccured
%-cured: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

%-decured.c: %-cured
	cp $*cured.i $@

%-decured: CC := ../front-end $(CC)

#../main: force
#	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean:
	rm -f *-cured *cured.c
	rm -f *-decured *-decured.c
	rm -f *.inst.c
	rm -f  *.[ios]
.PHONY: clean

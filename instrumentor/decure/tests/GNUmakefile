tests := test

top := ../..

front_end := ../driver/main
CC := $(front_end) -g -W -Wall -Werror

traces := $(tests:=.trace)
checks := $(tests:=.check)

countdir := $(top)/../libcountdown
countdowns := $(countdir)/countdown-1-1
lib := $(countdir)/libevent.la $(countdir)/libcyclic.la

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(checks)
.PHONY: check

$(checks): %.check: %.trace
	[ -r $< ]
.PHONY: $(checks)

$(tests:=.trace): %.trace: % $(countdowns)
	SAMPLER_EVENT_COUNTDOWNS=$(countdowns) ./$<
	touch $@

test: test.c $(lib) $(front_end) ../main
	$(LINK.c) $< $(LOADLIBES) $(LDLIBS) -o $@

../main: $(force)
	$(recurse)

$(countdowns): $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	rm -f $(traces) $(tests) *.[ios] *.cured.c *.inst.c
	rm -rf *.browser
	if [ -d .libs ]; then rmdir .libs; fi
.PHONY: clean

spotless: clean
.PHONY: spotless

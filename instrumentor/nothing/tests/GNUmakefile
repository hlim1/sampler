tests := main

top := ../..

front_end := ../driver/main
cyclic := acyclic
CC := $(front_end) --$(cyclic)
CFLAGS := -g -W -Wall -Werror

passed := $(tests:=.passed)

countdir := $(top)/../libcountdown
lib := $(countdir)/lib$(cyclic).la $(countdir)/libcountdown.la

force := force
recurse = $(MAKE) -C $(@D) $(@F)


########################################################################


all:
.PHONY: all

check: $(passed)
.PHONY: check

main.passed: main plugin.so
	SAMPLER_FILE=$@ SAMPLER_SPARSITY=1 ./$<
	touch $@

main: LDLIBS := -ldl
main: main.o ../main library.so $(front_end)
	$(LINK.o) -Wl,-rpath,. $@.o library.so $(LDLIBS) -o $@

library.so plugin.so: %.so: %.o ../main $(front_end)
	$(LINK.o) -shared $*.o $(LDLIBS) -o $@

main.o library.o plugin.o: %.o: %.c ../main $(front_end)

../main: $(force)
	$(recurse)

$(lib): $(force)
	$(recurse)

force:
.PHONY: force

clean:
	libtool --mode=clean 'rm -f' main library.so plugin.so $(passed) *.[ios] *.inst.c
.PHONY: clean

spotless: clean
.PHONY: spotless

CC := ../front-end $(CC)

all: run
.PHONY: all

run: test
	LD_LIBRARY_PATH=../liblog:../../libcountdown ./$^
.PHONY: run

test.o: test.c ../liblog/log.h ../main

../main: force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean:
	rm -f test test.o
.PHONY: clean

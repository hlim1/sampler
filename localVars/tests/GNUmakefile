prologue := ../liblog/log.h
CPPFLAGS := -include $(prologue)
LOADLIBES := -Wl,-rpath,../liblog -L../liblog -llog -Wl,-rpath,../../libcountdown -L../../libcountdown -lcountdown

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

CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -W -Wall -Werror -O9
libs := log log-stdio log-syscall
targets := $(foreach lib, $(libs), lib$(lib).so lib$(lib).a)
#strategy := stdio
strategy := syscall


all: decoder $(targets)
.PHONY: all

liblog.%: liblog-$(strategy).%
	rm -f $@
	ln -s $< $@

liblog-stdio.a: %: %(log.o) %(storage.o) %(stdio.o)
liblog-syscall.a: %: %(log.o) %(storage.o) %(syscall.o)

liblog-stdio.so liblog-syscall.so: liblog-%.so: log.o storage.o %.o
	$(LINK.o) -shared $^ -o $@

log.o: %.o: %.c %.h primitive.h storage.h
storage.o: %.o: %.c %.h
stdio.o syscall.o: %.o: %.c primitive.h storage.h

decoder.c: decoder.lex
	$(LEX) -o$@ $<

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

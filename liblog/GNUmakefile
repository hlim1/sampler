CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -W -Wall -Werror -O9
libs := log log-stdio log-syscall
targets := $(foreach lib, $(libs), lib$(lib).so lib$(lib).a)

-include strategy.mk


all: decoder $(targets)
.PHONY: all

liblog.%: liblog-$(strategy).% strategy.mk
	cp $< $@

liblog-stdio.a: %: %(storage.o) %(stdio.o)
liblog-syscall.a: %: %(storage.o) %(syscall.o)

liblog-stdio.so liblog-syscall.so: liblog-%.so: storage.o %.o
	$(LINK.o) -shared $^ -o $@

storage.o: %.o: %.c %.h
stdio.o syscall.o: %.o: %.c primitive.h storage.h

decoder.c: decoder.lex
	$(LEX) -o$@ $<

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

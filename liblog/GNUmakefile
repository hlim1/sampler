CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -W -Wall -Werror -g
libs := log log-stdio log-syscall
targets := $(foreach lib, $(libs), lib$(lib).so lib$(lib).a) libdecoder.a print-trace

-include strategy.mk


all: $(targets)
.PHONY: all

liblog.%: liblog-$(strategy).% strategy.mk
	cp $< $@

liblog-stdio.a: %: %(storage.o) %(stdio.o)
liblog-syscall.a: %: %(storage.o) %(syscall.o)

liblog-stdio.so liblog-syscall.so: liblog-%.so: storage.o %.o
	$(LINK.o) -shared $^ -o $@

storage.o: %.o: %.c %.h
stdio.o syscall.o: %.o: %.c primitive.h storage.h

libdecoder.a: %: %(decoder.o)

decoder.o: decoder.c decoder.h

print-trace: print-trace.o libdecoder.a

print-trace.o: print-trace.c decoder.h

clean:
	rm -f *.o *.a *.so
	rm -f decoder.c print-trace
.PHONY: clean

spotless: clean
.PHONY: spotless

CPPFLAGS := -D_GNU_SOURCE
CFLAGS := -W -Wall -Werror -O9
libs := log log-stdio log-syscall
targets := $(foreach lib, $(libs), lib$(lib).so lib$(lib).a)
strategy := stdio
#strategy := syscall


all: decoder $(targets)
.PHONY: all

liblog.a: %: %(log.o) %(storage.o)

liblog.so: log.o storage.o liblog-$(strategy).so
	$(LINK.o) -shared -Wl,-rpath,$$PWD $^ -o $@

log.o: %.o: %.c %.h primitive.h storage.h
storage.o: %.o: %.c %.h

liblog-stdio.a: %: %(stdio.o)
liblog-syscall.a: %: %(syscall.o)

liblog-stdio.so liblog-syscall.so: liblog-%.so: %.o
	$(LINK.o) -shared $^ -o $@

stdio.o syscall.o: %.o: %.c primitive.h storage.h

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

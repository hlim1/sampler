CFLAGS := -W -Wall -Werror -g
libs := liblog.a liblog.so


all: decoder $(libs)
.PHONY: all

liblog.a: %: %(log.o)

liblog.so: log.o
	$(LINK.o) -shared $^ -o $@

log.o: %.o: %.c log.h primitive.h

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

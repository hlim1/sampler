CFLAGS := -W -Wall -Werror -g
libs := liblog.a liblog.so

all: $(libs)

liblog.a: %: %(log.o)

liblog.so: log.o
	$(LINK.o) -shared $^ -o $@

log.o: %.o: %.c log.h

clean:
	rm -f *.o *.a *.so

CFLAGS := -W -Wall -Werror -g
lib := liblog.so

all: $(lib)

$(lib): log.o
	$(LINK.o) -shared $^ -o $@

log.o: %.o: %.c log.h

clean:
	rm -f *.o *.a *.so

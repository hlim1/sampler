CFLAGS := -W -Wall -Werror -g
libs := libcountdown.a libcountdown.so

all: $(libs)

libcountdown.a: %: %(countdown.o)

libcountdown.so: countdown.o
	$(LINK.o) -shared $^ -o $@

countdown.o: %.o: %.c countdown.h

clean:
	rm -f *.o *.a *.so

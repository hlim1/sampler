CPPFLAGS := -I../../libcountdown
CFLAGS := -W -Wall -Werror -g
libs := liblog.a liblog.so
countlib := ../../libcountdown/libcountdown.so

all: $(libs)

liblog.a: %: %(log.o)

liblog.so: log.o $(countlib)
	$(LINK.o) -shared $^ -o $@

log.o: %.o: %.c log.h ../../libcountdown/countdown.h

$(countlib): force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

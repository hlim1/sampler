libs := liblog.a liblog.so
libcountdown := ../../libcountdown
CPPFLAGS := -I$(libcountdown)
CFLAGS := -W -Wall -Werror -g
LDFLAGS := -L$(libcountdown)

all: $(libs)

liblog.a: %: %(log.o)

liblog.so: log.o $(libcountdown)/libcountdown.so
	$(LINK.o) -shared $< -lcountdown -o $@

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

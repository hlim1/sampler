CFLAGS := -W -Wall -Werror -g `gsl-config --cflags`
CPPFLAGS := -DHAVE_INLINE
LOADLIBES := `gsl-config --libs`

libs := libcountdown.a libcountdown.so

all: $(libs)
.PHONY: all

libcountdown.a: %: %(countdown.o)

libcountdown.so: countdown.o
	$(LINK.o) -shared $^ $(LOADLIBES) -o $@

countdown.o: %.o: %.c countdown.h

clean:
	rm -f *.o *.a *.so
.PHONY: clean

spotless: clean
.PHONY: spotless

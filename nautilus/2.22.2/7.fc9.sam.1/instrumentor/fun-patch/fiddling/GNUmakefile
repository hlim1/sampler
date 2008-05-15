CFLAGS := -W -Wall -Werror
LDLIBS := -ldl
link = $(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

all: replacement.so main
	./main
	LD_DEBUG=all LD_PRELOAD=./$< ./main

main: basis.o #replacement.o
	$(link) -rdynamic

%.so: %.o
	$(link) -shared

clean:
	rm -f main *.so *.o

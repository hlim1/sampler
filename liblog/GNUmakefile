CFLAGS := -W -Wall -Werror
lib := liblog.a

all: $(lib)

$(lib): $(lib)(log.o)

log.o: %.o: %.c %.h

clean:
	rm -f *.o *.a

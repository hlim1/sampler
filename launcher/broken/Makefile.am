AM_CFLAGS = -W -Wall -Werror -Wformat=2
INCLUDES = $(BROKEN_CFLAGS) -I/usr/include/python2.2

MOSTLYCLEANFILES = *.so

noinst_LIBRARIES = libbroken.a

traylib_DATA = broken.so


########################################################################


libbroken_a_SOURCES = broken.c


broken.so: %.so: lib%.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $^ -Wl,--no-whole-archive $(BROKEN_LIBS) -L/usr/lib/python2.2/config -lpython2.2 -lutil

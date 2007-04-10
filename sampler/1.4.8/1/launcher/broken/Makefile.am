AM_CFLAGS = -W -Wall -Werror -Wformat=2
INCLUDES = $(BROKEN_CFLAGS) $(PYTHON_CFLAGS)

MOSTLYCLEANFILES = *.so

noinst_LIBRARIES = libbroken.a

traylib_DATA = broken.so


########################################################################


libbroken_a_SOURCES = broken.c


broken.so: %.so: lib%.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $^ -Wl,--no-whole-archive $(BROKEN_LIBS) $(PYTHON_LIBS) -lutil

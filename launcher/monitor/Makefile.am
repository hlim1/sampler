AM_CFLAGS = -fpic -Wall -Werror -Wformat=2 -Wno-return-type
INCLUDES = $(MONITOR_CFLAGS) $(PYTHON_CFLAGS)

EXTRA_DIST =					\
	monitor.override

BUILT_SOURCES =					\
	monitor-wrap.c

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-skels.c				\
	*-wrap.c				\
	*.defs					\
	*.so

traylib_DATA = monitor.so


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


########################################################################


monitor.so: %.so: lib%.a
	$(CC) $(AM_CFLAGS) $(CFLAGS) $(LDFLAGS) $(PYTHON_LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive $(MONITOR_LIBS) $(PYTHON_LIBS)


noinst_LIBRARIES = libmonitor.a

libmonitor_a_SOURCES =				\
	monitor.c				\
	monitor.h				\
	monitor-module.c			\
	monitor-module.h			\
	monitor-wrap.c

monitor-wrap.c: %-wrap.c: %.override %.defs
	pygtk-codegen-2.0 --prefix $* --override $< $*.defs |		\
	sed 's/^const \\(PyMethodDef $*_functions\\[\\]\\)/\\1/'	\
	>$@

monitor.defs: monitor.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@

.DELETE_ON_ERROR:

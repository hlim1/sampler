AM_CFLAGS = -Wall -Werror -Wformat=2
INCLUDES = $(MONITOR_CFLAGS) $(PYTHON_CFLAGS)

defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

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
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive $(MONITOR_LIBS) $(PYTHON_LIBS) -lutil


noinst_LIBRARIES = libmonitor.a

libmonitor_a_SOURCES =				\
	monitor.c				\
	monitor.h				\
	monitor-module.c			\
	monitor-module.h			\
	monitor-wrap.c

monitor-wrap.c: %-wrap.c: %.override %.defs
	pygtk-codegen-2.0				\
	  --prefix $*					\
	  --register $(defsdir)/gdk-types.defs		\
	  --register $(defsdir)/gtk-types.defs		\
	  --register $(defsdir)/bonobo-types.defs	\
	  --override $<					\
	  $*.defs >$@

monitor.defs: monitor.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@

.DELETE_ON_ERROR:

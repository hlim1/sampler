INCLUDES = $(MONITOR_CFLAGS) -I/usr/include/python2.2

defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

EXTRA_DIST =					\
	Sampler_Monitor.idl			\
	Sampler_Monitor.server			\
	monitor.override

BUILT_SOURCES =					\
	Sampler_Monitor-common.c		\
	Sampler_Monitor-skels.c			\
	Sampler_Monitor.h			\
	monitor-wrap.c

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-skels.c				\
	*-wrap.c				\
	*.defs					\
	*.so					\
	Sampler_Monitor.h

TESTS = Sampler_Monitor.server
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout


all-local: monitor.so


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


########################################################################


monitor.so: %.so: lib%.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive $(MONITOR_LIBS) -L/usr/lib/python2.2/config -lpython2.2 -lutil


noinst_LIBRARIES = libmonitor.a

libmonitor_a_SOURCES =				\
	Sampler_Monitor-common.c		\
	Sampler_Monitor-skels.c			\
	Sampler_Monitor.h			\
	monitor.c				\
	monitor.h				\
	monitor-module.c			\
	monitor-module.h			\
	monitor-wrap.c

monitor-wrap.c: %-wrap.c: %.defs %.override
	pygtk-codegen-2.0				\
	  --prefix $*					\
	  --register $(defsdir)/gdk-types.defs		\
	  --register $(defsdir)/gtk-types.defs		\
	  --register $(defsdir)/bonobo-types.defs	\
	  --override $*.override			\
	  $*.defs >$@.tmp
	mv $@.tmp $@

monitor.defs: monitor.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@.tmp
	mv $@.tmp $@

Sampler_Monitor.h Sampler_Monitor-skels.c Sampler_Monitor-common.c: Sampler_Monitor.idl
	orbit-idl-2 --nostubs $(patsubst %, --include %, $(srcdir) $(shell pkg-config --variable idlinclude libbonobo-2.0)) $<

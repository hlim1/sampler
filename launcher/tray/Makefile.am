SUBDIRS = libegg

INCLUDES = $(TRAY_ICON_CFLAGS) $(TRAY_SAMPLER_CFLAGS) -I/usr/include/python2.2

defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

EXTRA_DIST =					\
	Sampler_ReportCollector.idl		\
	sampler.override			\
	trayicon.override

BUILT_SOURCES =					\
	Config.py				\
	Sampler_ReportCollector-common.c	\
	Sampler_ReportCollector-skels.c		\
	Sampler_ReportCollector.h		\
	sampler-wrap.c				\
	trayicon-wrap.c

noinst_LIBRARIES = libtrayicon.a libsampler.a

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-skels.c				\
	*-wrap.c				\
	*.defs					\
	*.so					\
	Sampler_ReportCollector.h


all-local: trayicon.so sampler.so


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


########################################################################


trayicon.defs: %.defs: libegg/tray/egg%.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@.tmp
	mv $@.tmp $@

trayicon-wrap.c: %-wrap.c: %.defs %.override
	pygtk-codegen-2.0			\
	  --prefix $*				\
	  --register $(defsdir)/gdk-types.defs	\
	  --register $(defsdir)/gtk-types.defs	\
	  --override $*.override		\
	  $*.defs >$@.tmp
	mv $@.tmp $@

libegg/tray/libtray.a: force
	$(MAKE) -C $(@D) $(@F)
force:
.PHONY: force

libtrayicon_a_SOURCES =				\
	trayicon-wrap.c				\
	trayiconmodule.c

trayicon.so: %.so: lib%.a libegg/tray/libtray.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive -L/usr/lib/python2.2/config -lpython2.2 -ldl -lm -lpthread -lutil -Llibegg/tray -ltray $(EGG_TRAY_LIBS) $(TRAY_ICON_LIBS)


########################################################################


Sampler_ReportCollector.h Sampler_ReportCollector-skels.c Sampler_ReportCollector-common.c: Sampler_ReportCollector.idl
	orbit-idl-2 --nostubs $(patsubst %, --include %, $(srcdir) $(shell pkg-config --variable idlinclude libbonobo-2.0)) $<

sampler.defs: collector.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@.tmp
	mv $@.tmp $@

sampler-wrap.c: %-wrap.c: %.defs %.override
	pygtk-codegen-2.0				\
	  --prefix $*					\
	  --register $(defsdir)/gdk-types.defs		\
	  --register $(defsdir)/gtk-types.defs		\
	  --register $(defsdir)/bonobo-types.defs	\
	  --override $*.override			\
	  $*.defs >$@.tmp
	mv $@.tmp $@

libsampler_a_SOURCES =				\
	Sampler_ReportCollector-common.c	\
	Sampler_ReportCollector-skels.c		\
	Sampler_ReportCollector.h		\
	collector.c				\
	collector.h				\
	sampler-module.c			\
	sampler-wrap.c

sampler.so: %.so: lib%.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $^ -Wl,--no-whole-archive -L/usr/lib/python2.2/config -lpython2.2 -lutil $(TRAY_SAMPLER_LIBS)

SUBDIRS = corba libegg

noinst_LIBRARIES = libtrayicon.a

libtrayicon_a_SOURCES =				\
	trayicon.c				\
	trayiconmodule.c

libtrayicon_a_LIBADD = libegg/tray/libtray.a

BUILT_SOURCES = trayicon.c
EXTRA_DIST = trayicon.override

INCLUDES = $(LAUNCHER_TRAY_CFLAGS) -I/usr/include/python2.2 -DGETTEXT_PACKAGE='"sampler"'
CFLAGS = -O9 -Wall -Werror
LDFLAGS = $(LAUNCHER_TRAY_LIBS)

trayicon.defs: %.defs: libegg/tray/egg%.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@.tmp
	mv $@.tmp $@


defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

trayicon.c: %.c: %.defs %.override
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

trayicon.so: %.so: %.o %module.o $(libtrayicon_a_LIBADD)
	$(CC) $(CFLAGS) $(LDFLAGS) -shared $^ -o $@

all-local: trayicon.so


MOSTLYCLEANFILES =				\
	trayicon.so				\
	trayicon.c				\
	trayicon.defs

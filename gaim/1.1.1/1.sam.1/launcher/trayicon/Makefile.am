AM_CFLAGS = -Wall -Werror -Wformat=2

SUBDIRS = libegg

INCLUDES = $(TRAY_ICON_CFLAGS) $(PYTHON_CFLAGS)

defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

EXTRA_DIST = trayicon.override

BUILT_SOURCES = trayicon-wrap.c

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-skels.c				\
	*-wrap.c				\
	*.defs					\
	*.so

traylib_DATA = trayicon.so


dist-hook:
	rm $(BUILT_SOURCES:%=$(distdir)/%)


########################################################################


trayicon.so: %.so: lib%.a libegg/tray/libtray.a
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--no-undefined -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive $(TRAY_ICON_LIBS) $(PYTHON_LIBS) -lpthread -lutil -Llibegg/tray -ltray -L/usr/X11R6/lib -lX11

noinst_LIBRARIES = libtrayicon.a

libtrayicon_a_SOURCES =				\
	trayicon-wrap.c				\
	trayicon-module.c			\
	trayicon-module.h

trayicon-wrap.c: %-wrap.c: %.override %.defs
	pygtk-codegen-2.0			\
	  --prefix $*				\
	  --register $(defsdir)/gdk-types.defs	\
	  --register $(defsdir)/gtk-types.defs	\
	  --override $<				\
	  $*.defs >$@

trayicon.defs: %.defs: libegg/tray/egg%.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@

libegg/tray/libtray.a: force
	$(MAKE) -C $(@D) $(@F)
force:
.PHONY: force

.DELETE_ON_ERROR:

INCLUDES = $(BONOBO_CFLAGS) -I/usr/include/python2.2 `pkg-config --cflags gtk+-2.0 pygtk-2.0`
CFLAGS = -g -Wimplicit
LDFLAGS = $(BONOBO_LIBS)

noinst_PROGRAMS = client uploader-main

client_SOURCES =				\
	Sampler_Uploader-common.c		\
	Sampler_Uploader-stubs.c		\
	client.c

uploader_main_SOURCES =				\
	Sampler_Uploader-common.c		\
	Sampler_Uploader-skels.c		\
	uploader-main.c				\
	uploader.c				\
	uploader.h

EXTRA_DIST =					\
	oaf.dtd					\
	Sampler_Uploader.idl			\
	sampler.server

BUILT_SOURCES = Sampler_Uploader.h Sampler_Uploader-common.c

TESTS = sampler.server
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

Sampler_Uploader.h Sampler_Uploader-common.c Sampler_Uploader-skels.c Sampler_Uploader-stubs.c: Sampler_Uploader.idl
	orbit-idl-2 --include /usr/share/idl/bonobo-2.0 --include /usr/share/idl/bonobo-activation-2.0 $<

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-imodule.c				\
	*.so					\
	*-skels.c				\
	*-stubs.c				\
	*.defs					\
	Sampler_Uploader.h			\
	py-uploader.c

uploader.defs: %.defs: %.h
	python /usr/share/pygtk/2.0/codegen/h2def.py $< >$@.tmp
	mv $@.tmp $@


defsdir = "`pkg-config --variable=defsdir pygtk-2.0`"

py-uploader.c: py-%.c: %.defs %.override
	pygtk-codegen-2.0				\
	  --prefix $*					\
	  --register $(defsdir)/gdk-types.defs		\
	  --register $(defsdir)/gtk-types.defs		\
	  --register $(defsdir)/bonobo-types.defs	\
	  --override $*.override			\
	  $*.defs >$@.tmp
	mv $@.tmp $@

noinst_LIBRARIES = libuploader_module.a
libuploader_module_a_SOURCES = py-uploader.c py-uploader-module.c uploader.c Sampler_Uploader-common.c Sampler_Uploader-skels.c

all-local: uploader.so

uploader.so: libuploader_module.a
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $@ -Wl,--whole-archive $< -Wl,--no-whole-archive

INCLUDES = $(BONOBO_CFLAGS)
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

Sampler_Uploader.h Sampler_Uploader-common.c Sampler_Uploader-skels.c: Sampler_Uploader.idl
	orbit-idl-2 --include /usr/share/idl/bonobo-2.0 --include /usr/share/idl/bonobo-activation-2.0 $<

MOSTLYCLEANFILES =				\
	*-common.c				\
	*-imodule.c				\
	*_module.so				\
	*-skels.c				\
	*-stubs.c				\
	Sampler_Uploader.h

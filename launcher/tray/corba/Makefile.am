INCLUDES = $(BONOBO_CFLAGS)
CFLAGS = -fPIC
LDFLAGS = $(BONOBO_LIBS)

noinst_LIBRARIES = libsampler_module.a

libsampler_module_a_SOURCES = sampler-imodule.c

EXTRA_DIST =					\
	oaf.dtd					\
	sampler.idl				\
	sampler.server

BUILT_SOURCES = sampler.h sampler-common.c

TESTS = sampler.server
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

idldir = /usr/share/idl

sampler.h sampler-common.c sampler-imodule.c: sampler.idl
	orbit-idl-2 --include $(idldir) --imodule $<

sampler_module.so: %_module.so: %-imodule.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -shared $^ $(LDFLAGS)

all-local: sampler_module.so

MOSTLYCLEANFILES =				\
	sampler-common.c			\
	sampler-imodule.c			\
	sampler.h				\
	sampler_module.so

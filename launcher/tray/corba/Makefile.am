INCLUDES = $(BONOBO_CFLAGS)
CFLAGS = -fPIC
LDFLAGS = $(BONOBO_LIBS)

noinst_LIBRARIES = libsampler_module.a

libsampler_module_a_SOURCES = sampler-imodule.c

TESTS = sampler.server
TESTS_ENVIRONMENT = $(XMLLINT) --valid --noout

idldir = /usr/share/idl

sampler-imodule.c: %-imodule.c: %.idl
	orbit-idl-2 --include $(idldir) --imodule $<

sampler_module.so: %_module.so: %-imodule.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -shared $^ $(LDFLAGS)

all-local: sampler_module.so

MOSTLYCLEANFILES =				\
	sampler-common.c			\
	sampler-imodule.c			\
	sampler.h				\
	sampler_module.so

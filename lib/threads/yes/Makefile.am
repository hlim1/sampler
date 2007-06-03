AM_CPPFLAGS = -DCBI_THREADS
AM_CFLAGS = -ffast-math -fpic -pthread
AM_LDFLAGS = -Wl,--unresolved-symbols=ignore-in-shared-libs -Wl,--wrap,pthread_create

include ../threads.mk

threads_yes_HEADERS = $(headers)

lib_LTLIBRARIES =				\
	libsampler-fixed_r.la			\
	libsampler-offline_r.la			\
	libsampler-online_r.la

libsampler_fixed_r_la_SOURCES = ../random-fixed.c $(common)
libsampler_offline_r_la_SOURCES = ../random-offline.c $(common)
libsampler_online_r_la_SOURCES = ../random-online.c $(common)

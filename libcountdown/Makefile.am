INCLUDES = `gsl-config --cflags`


lib_LTLIBRARIES = libcountdown.la libacyclic.la libcyclic.la

libcountdown_la_SOURCES = countdown.h countdown.c
libacyclic_la_SOURCES = acyclic.h acyclic.c
libcyclic_la_SOURCES = cyclic.h cyclic.c


noinst_PROGRAMS = mean
mean_LDFLAGS = `gsl-config --libs`

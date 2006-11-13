AM_CFLAGS = -W -Wall -Werror -Wformat=2
INCLUDES = @GLIB_CFLAGS@


if WITH_GNOME
gnome_headers =					\
	g-object-unref.h			\
	g-object-unref-unit.h

gnome_sources =					\
	g-object-unref.c			\
	g-object-unref-classify.c
endif


schemes_HEADERS =				\
	$(gnome_headers)			\
	bounds.h				\
	bounds-unit.h				\
	branches.h				\
	branches-unit.h				\
	function-entries.h			\
	function-entries-unit.h			\
	returns.h				\
	returns-unit.h				\
	scalar-pairs.h				\
	scalar-pairs-unit.h			\
	tuple-1.h				\
	tuple-2.h				\
	tuple-3.h				\
	tuple-4.h


schemes_LIBRARIES = libschemes.a

libschemes_a_SOURCES =				\
	$(gnome_sources)			\
	bounds.c				\
	bounds.h				\
	branches.c				\
	branches.h				\
	function-entries.c			\
	function-entries.h			\
	returns.c				\
	returns.h				\
	samples.c				\
	samples.h				\
	scalar-pairs.c				\
	scalar-pairs.h				\
	timestamps.c				\
	tuple-1.c				\
	tuple-1.h				\
	tuple-2.c				\
	tuple-2.h				\
	tuple-3.c				\
	tuple-3.h				\
	tuple-4.c				\
	tuple-4.h

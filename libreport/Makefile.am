liblib_LIBRARIES =				\
	libreport.a				\
	libreport_r.a

libinclude_HEADERS =				\
	requires.h				\
	unit.h

INCLUDES = -D_GNU_SOURCE -W -Wall -Werror

sources =					\
	anchor.h				\
	lock.h					\
	report.c				\
	report.h				\
	requires.h				\
	unit.c					\
	unit.h

libreport_a_SOURCES = $(sources)
libreport_a_CFLAGS = -include $(top_srcdir)/libthreads/no-threads.h

libreport_r_a_SOURCES = $(sources) lock.c
libreport_r_a_CFLAGS = -include $(top_srcdir)/libthreads/threads.h -pthread

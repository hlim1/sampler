INCLUDES = -I../libodbc++
CFLAGS = -W -Wall -Werror

noinst_PROGRAMS = populate
populate_SOURCES = populate.cc
populate_LDADD = ../libodbc++/libodbc++.a -lodbc

../libodbc++/libodbc++.a: force
	$(MAKE) -C $(@C) $(@D)

force:

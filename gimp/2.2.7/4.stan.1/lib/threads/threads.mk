libraries =					\
	libearly.a				\
	liblate.a				\
	librandom-fixed.a			\
	librandom-offline.a			\
	librandom-online.a

headers =					\
	lock.h					\
	once.h

libearly_a_SOURCES = hijack.c

liblate_a_SOURCES =				\
	../countdown.c				\
	../registry.c				\
	../report.c				\
	../timestamps-set.c

librandom_fixed_a_SOURCES = ../random-fixed.c
librandom_offline_a_SOURCES = ../random-offline.c
librandom_online_a_SOURCES = ../random-online.c

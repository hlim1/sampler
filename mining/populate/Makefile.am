libdecoder = ../../liblog/libdecoder.a

noinst_PROGRAMS = populate
populate_LDADD = -lpq++ $(libdecoder)
populate_SOURCES =				\
	database.cc				\
	database.h				\
	decoder.cc				\
	populate.cc				\
	require.cc				\
	require.h				\
	session.cc				\
	session.h


$(libdecoder): force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

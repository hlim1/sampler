libdecoder = ../../liblog/libdecoder.a

noinst_PROGRAMS = populate
populate_LDADD = -lcurses -lpq++ $(libdecoder)
populate_SOURCES =				\
	Progress.cc				\
	Progress.h				\
	Sample.cc				\
	Sample.h				\
	Session.cc				\
	Session.h				\
	Site.cc					\
	Site.h					\
	decoder.cc				\
	populate.cc				\
	quote.cc				\
	quote.h					\
	require.cc				\
	require.h


$(libdecoder): force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

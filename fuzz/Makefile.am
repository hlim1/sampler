CXXFLAGS = -g -W -Wall -Werror

libdecoder = ../../liblog/libdecoder.a

noinst_PROGRAMS = fuzz
fuzz_SOURCES = fuzz.cc


$(libdecoder): force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

noinst_HEADERS = primitive.h


lib_LIBRARIES = libdecoder.a liblog-stdio.a liblog-storage.a liblog-syscall.a

libdecoder_a_SOURCES =				\
	decoder.l				\
	decoder.h

liblog_storage_a_SOURCES =			\
	log.h					\
	storage.c				\
	storage.h

liblog_stdio_a_SOURCES = stdio.c

liblog_syscall_a_SOURCES = syscall.c


noinst_PROGRAMS = print-trace

print_trace_LDADD = libdecoder.a

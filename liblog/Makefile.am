noinst_HEADERS = primitive.h


lib_LTLIBRARIES = libdecoder.la liblog-stdio.la liblog-storage.la liblog-syscall.la

libdecoder_la_SOURCES =				\
	decoder.l				\
	decoder.h

liblog_storage_la_SOURCES =			\
	log.h					\
	storage.c				\
	storage.h

liblog_stdio_la_SOURCES = stdio.c

liblog_syscall_la_SOURCES = syscall.c


noinst_PROGRAMS = print-trace

print_trace_LDADD = libdecoder.la

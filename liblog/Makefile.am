lib_LTLIBRARIES = libdecoder.la liblog-storage.la liblog-stdio.la liblog-syscall.la

libdecoder_la_SOURCES =				\
	decoder.l				\
	decoder.h

liblog_storage_la_SOURCES =			\
	log.h					\
	primitive.h				\
	storage.c				\
	storage.h

liblog_stdio_la_SOURCES = stdio.c
liblog_stdio_la_LIBADD = liblog-storage.la

liblog_syscall_la_SOURCES = syscall.c
liblog_syscall_la_LIBADD = liblog-storage.la


noinst_PROGRAMS = print-trace

print_trace_LDADD = libdecoder.la

# 1 "../../src/src/rijndael.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "/var/local/liblit/forensics/sampler/instrumentor/daikount/libdaikount/daikount.h" 1




struct Invariant
{
  const struct Invariant *next;

  unsigned counters[3];

  const char * const file;
  const unsigned line;
  const char * const function;
  const char * const left;
  const char * const right;
  const unsigned id;
};


static inline void registerInvariant(struct Invariant *) __attribute__((no_instrument_function));

static inline void registerInvariant(struct Invariant *invariant)
{
  extern const struct Invariant *invariants;

  invariant->next = invariants;
  invariants = invariant;
}
# 2 "<command line>" 2
# 1 "../../src/src/rijndael.c"
# 10 "../../src/src/rijndael.c"
# 1 "/usr/include/stdio.h" 1 3
# 28 "/usr/include/stdio.h" 3
# 1 "/usr/include/features.h" 1 3
# 291 "/usr/include/features.h" 3
# 1 "/usr/include/sys/cdefs.h" 1 3
# 292 "/usr/include/features.h" 2 3
# 320 "/usr/include/features.h" 3
# 1 "/usr/include/gnu/stubs.h" 1 3
# 321 "/usr/include/features.h" 2 3
# 29 "/usr/include/stdio.h" 2 3





# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 201 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef unsigned int size_t;
# 35 "/usr/include/stdio.h" 2 3

# 1 "/usr/include/bits/types.h" 1 3
# 29 "/usr/include/bits/types.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 30 "/usr/include/bits/types.h" 2 3


typedef unsigned char __u_char;
typedef unsigned short __u_short;
typedef unsigned int __u_int;
typedef unsigned long __u_long;

__extension__ typedef unsigned long long int __u_quad_t;
__extension__ typedef long long int __quad_t;
# 49 "/usr/include/bits/types.h" 3
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;

typedef __quad_t *__qaddr_t;

typedef __u_quad_t __dev_t;
typedef __u_int __uid_t;
typedef __u_int __gid_t;
typedef __u_long __ino_t;
typedef __u_int __mode_t;
typedef __u_int __nlink_t;
typedef long int __off_t;
typedef __quad_t __loff_t;
typedef int __pid_t;
typedef int __ssize_t;
typedef __u_long __rlim_t;
typedef __u_quad_t __rlim64_t;
typedef __u_int __id_t;

typedef struct
  {
    int __val[2];
  } __fsid_t;


typedef int __daddr_t;
typedef char *__caddr_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __swblk_t;

typedef long int __clock_t;


typedef int __clockid_t;


typedef int __timer_t;






typedef int __key_t;


typedef unsigned short int __ipc_pid_t;



typedef long int __blksize_t;




typedef long int __blkcnt_t;
typedef __quad_t __blkcnt64_t;


typedef __u_long __fsblkcnt_t;
typedef __u_quad_t __fsblkcnt64_t;


typedef __u_long __fsfilcnt_t;
typedef __u_quad_t __fsfilcnt64_t;


typedef __u_quad_t __ino64_t;


typedef __loff_t __off64_t;


typedef long int __t_scalar_t;
typedef unsigned long int __t_uscalar_t;


typedef int __intptr_t;


typedef unsigned int __socklen_t;




# 1 "/usr/include/bits/pthreadtypes.h" 1 3
# 23 "/usr/include/bits/pthreadtypes.h" 3
# 1 "/usr/include/bits/sched.h" 1 3
# 68 "/usr/include/bits/sched.h" 3
struct __sched_param
  {
    int __sched_priority;
  };
# 24 "/usr/include/bits/pthreadtypes.h" 2 3


struct _pthread_fastlock
{
  long int __status;
  int __spinlock;

};



typedef struct _pthread_descr_struct *_pthread_descr;





typedef struct __pthread_attr_s
{
  int __detachstate;
  int __schedpolicy;
  struct __sched_param __schedparam;
  int __inheritsched;
  int __scope;
  size_t __guardsize;
  int __stackaddr_set;
  void *__stackaddr;
  size_t __stacksize;
} pthread_attr_t;



typedef struct
{
  struct _pthread_fastlock __c_lock;
  _pthread_descr __c_waiting;
} pthread_cond_t;



typedef struct
{
  int __dummy;
} pthread_condattr_t;


typedef unsigned int pthread_key_t;





typedef struct
{
  int __m_reserved;
  int __m_count;
  _pthread_descr __m_owner;
  int __m_kind;
  struct _pthread_fastlock __m_lock;
} pthread_mutex_t;



typedef struct
{
  int __mutexkind;
} pthread_mutexattr_t;



typedef int pthread_once_t;
# 140 "/usr/include/bits/pthreadtypes.h" 3
typedef unsigned long int pthread_t;
# 144 "/usr/include/bits/types.h" 2 3
# 37 "/usr/include/stdio.h" 2 3









typedef struct _IO_FILE FILE;





# 62 "/usr/include/stdio.h" 3
typedef struct _IO_FILE __FILE;
# 72 "/usr/include/stdio.h" 3
# 1 "/usr/include/libio.h" 1 3
# 32 "/usr/include/libio.h" 3
# 1 "/usr/include/_G_config.h" 1 3
# 14 "/usr/include/_G_config.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 294 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef long int wchar_t;
# 321 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef unsigned int wint_t;
# 15 "/usr/include/_G_config.h" 2 3
# 24 "/usr/include/_G_config.h" 3
# 1 "/usr/include/wchar.h" 1 3
# 48 "/usr/include/wchar.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 49 "/usr/include/wchar.h" 2 3

# 1 "/usr/include/bits/wchar.h" 1 3
# 51 "/usr/include/wchar.h" 2 3
# 71 "/usr/include/wchar.h" 3
typedef struct
{
  int __count;
  union
  {
    wint_t __wch;
    char __wchb[4];
  } __value;
} __mbstate_t;
# 25 "/usr/include/_G_config.h" 2 3

typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
# 44 "/usr/include/_G_config.h" 3
# 1 "/usr/include/gconv.h" 1 3
# 28 "/usr/include/gconv.h" 3
# 1 "/usr/include/wchar.h" 1 3
# 48 "/usr/include/wchar.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 49 "/usr/include/wchar.h" 2 3
# 29 "/usr/include/gconv.h" 2 3


# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 32 "/usr/include/gconv.h" 2 3





enum
{
  __GCONV_OK = 0,
  __GCONV_NOCONV,
  __GCONV_NODB,
  __GCONV_NOMEM,

  __GCONV_EMPTY_INPUT,
  __GCONV_FULL_OUTPUT,
  __GCONV_ILLEGAL_INPUT,
  __GCONV_INCOMPLETE_INPUT,

  __GCONV_ILLEGAL_DESCRIPTOR,
  __GCONV_INTERNAL_ERROR
};



enum
{
  __GCONV_IS_LAST = 0x0001,
  __GCONV_IGNORE_ERRORS = 0x0002
};



struct __gconv_step;
struct __gconv_step_data;
struct __gconv_loaded_object;
struct __gconv_trans_data;



typedef int (*__gconv_fct) (struct __gconv_step *, struct __gconv_step_data *,
                            __const unsigned char **, __const unsigned char *,
                            unsigned char **, size_t *, int, int);


typedef int (*__gconv_init_fct) (struct __gconv_step *);
typedef void (*__gconv_end_fct) (struct __gconv_step *);



typedef int (*__gconv_trans_fct) (struct __gconv_step *,
                                  struct __gconv_step_data *, void *,
                                  __const unsigned char *,
                                  __const unsigned char **,
                                  __const unsigned char *, unsigned char **,
                                  size_t *);


typedef int (*__gconv_trans_context_fct) (void *, __const unsigned char *,
                                          __const unsigned char *,
                                          unsigned char *, unsigned char *);


typedef int (*__gconv_trans_query_fct) (__const char *, __const char ***,
                                        size_t *);


typedef int (*__gconv_trans_init_fct) (void **, const char *);
typedef void (*__gconv_trans_end_fct) (void *);

struct __gconv_trans_data
{

  __gconv_trans_fct __trans_fct;
  __gconv_trans_context_fct __trans_context_fct;
  __gconv_trans_end_fct __trans_end_fct;
  void *__data;
  struct __gconv_trans_data *__next;
};



struct __gconv_step
{
  struct __gconv_loaded_object *__shlib_handle;
  __const char *__modname;

  int __counter;

  char *__from_name;
  char *__to_name;

  __gconv_fct __fct;
  __gconv_init_fct __init_fct;
  __gconv_end_fct __end_fct;



  int __min_needed_from;
  int __max_needed_from;
  int __min_needed_to;
  int __max_needed_to;


  int __stateful;

  void *__data;
};



struct __gconv_step_data
{
  unsigned char *__outbuf;
  unsigned char *__outbufend;



  int __flags;



  int __invocation_counter;



  int __internal_use;

  __mbstate_t *__statep;
  __mbstate_t __state;



  struct __gconv_trans_data *__trans;
};



typedef struct __gconv_info
{
  size_t __nsteps;
  struct __gconv_step *__steps;
  __extension__ struct __gconv_step_data __data [];
} *__gconv_t;
# 45 "/usr/include/_G_config.h" 2 3
typedef union
{
  struct __gconv_info __cd;
  struct
  {
    struct __gconv_info __cd;
    struct __gconv_step_data __data;
  } __combined;
} _G_iconv_t;

typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));
# 33 "/usr/include/libio.h" 2 3
# 53 "/usr/include/libio.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stdarg.h" 1 3
# 43 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stdarg.h" 3
typedef __builtin_va_list __gnuc_va_list;
# 54 "/usr/include/libio.h" 2 3
# 162 "/usr/include/libio.h" 3
struct _IO_jump_t; struct _IO_FILE;
# 172 "/usr/include/libio.h" 3
typedef void _IO_lock_t;





struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;



  int _pos;
# 195 "/usr/include/libio.h" 3
};


enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
# 263 "/usr/include/libio.h" 3
struct _IO_FILE {
  int _flags;




  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;

  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset;



  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];



  _IO_lock_t *_lock;
# 311 "/usr/include/libio.h" 3
  __off64_t _offset;





  void *__pad1;
  void *__pad2;

  int _mode;

  char _unused2[15 * sizeof (int) - 2 * sizeof (void *)];

};


typedef struct _IO_FILE _IO_FILE;


struct _IO_FILE_plus;

extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
# 350 "/usr/include/libio.h" 3
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);







typedef __ssize_t __io_write_fn (void *__cookie, __const char *__buf,
                                 size_t __n);







typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);


typedef int __io_close_fn (void *__cookie);
# 402 "/usr/include/libio.h" 3
extern int __underflow (_IO_FILE *) ;
extern int __uflow (_IO_FILE *) ;
extern int __overflow (_IO_FILE *, int) ;
extern wint_t __wunderflow (_IO_FILE *) ;
extern wint_t __wuflow (_IO_FILE *) ;
extern wint_t __woverflow (_IO_FILE *, wint_t) ;
# 432 "/usr/include/libio.h" 3
extern int _IO_getc (_IO_FILE *__fp) ;
extern int _IO_putc (int __c, _IO_FILE *__fp) ;
extern int _IO_feof (_IO_FILE *__fp) ;
extern int _IO_ferror (_IO_FILE *__fp) ;

extern int _IO_peekc_locked (_IO_FILE *__fp) ;





extern void _IO_flockfile (_IO_FILE *) ;
extern void _IO_funlockfile (_IO_FILE *) ;
extern int _IO_ftrylockfile (_IO_FILE *) ;
# 462 "/usr/include/libio.h" 3
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
                        __gnuc_va_list, int *__restrict) ;
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
                         __gnuc_va_list) ;
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t) ;
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t) ;

extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int) ;
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int) ;

extern void _IO_free_backup_area (_IO_FILE *) ;
# 73 "/usr/include/stdio.h" 2 3
# 86 "/usr/include/stdio.h" 3


typedef _G_fpos_t fpos_t;




# 138 "/usr/include/stdio.h" 3
# 1 "/usr/include/bits/stdio_lim.h" 1 3
# 139 "/usr/include/stdio.h" 2 3



extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;









extern int remove (__const char *__filename) ;

extern int rename (__const char *__old, __const char *__new) ;






extern FILE *tmpfile (void) ;
# 173 "/usr/include/stdio.h" 3
extern char *tmpnam (char *__s) ;

# 183 "/usr/include/stdio.h" 3
extern char *tmpnam_r (char *__s) ;
# 195 "/usr/include/stdio.h" 3
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__malloc__));





extern int fclose (FILE *__stream) ;

extern int fflush (FILE *__stream) ;




extern int fflush_unlocked (FILE *__stream) ;
# 218 "/usr/include/stdio.h" 3



extern FILE *fopen (__const char *__restrict __filename,
                    __const char *__restrict __modes) ;

extern FILE *freopen (__const char *__restrict __filename,
                      __const char *__restrict __modes,
                      FILE *__restrict __stream) ;
# 241 "/usr/include/stdio.h" 3

# 252 "/usr/include/stdio.h" 3
extern FILE *fdopen (int __fd, __const char *__modes) ;
# 273 "/usr/include/stdio.h" 3



extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) ;



extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
                    int __modes, size_t __n) ;





extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
                       size_t __size) ;


extern void setlinebuf (FILE *__stream) ;





extern int fprintf (FILE *__restrict __stream,
                    __const char *__restrict __format, ...) ;

extern int printf (__const char *__restrict __format, ...) ;

extern int sprintf (char *__restrict __s,
                    __const char *__restrict __format, ...) ;


extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
                     __gnuc_va_list __arg) ;

extern int vprintf (__const char *__restrict __format, __gnuc_va_list __arg)
     ;

extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
                     __gnuc_va_list __arg) ;





extern int snprintf (char *__restrict __s, size_t __maxlen,
                     __const char *__restrict __format, ...)
     __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char *__restrict __s, size_t __maxlen,
                      __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 3, 0)));

# 351 "/usr/include/stdio.h" 3


extern int fscanf (FILE *__restrict __stream,
                   __const char *__restrict __format, ...) ;

extern int scanf (__const char *__restrict __format, ...) ;

extern int sscanf (__const char *__restrict __s,
                   __const char *__restrict __format, ...) ;

# 381 "/usr/include/stdio.h" 3


extern int fgetc (FILE *__stream) ;
extern int getc (FILE *__stream) ;


extern int getchar (void) ;








extern int getc_unlocked (FILE *__stream) ;
extern int getchar_unlocked (void) ;




extern int fgetc_unlocked (FILE *__stream) ;





extern int fputc (int __c, FILE *__stream) ;
extern int putc (int __c, FILE *__stream) ;


extern int putchar (int __c) ;








extern int fputc_unlocked (int __c, FILE *__stream) ;




extern int putc_unlocked (int __c, FILE *__stream) ;
extern int putchar_unlocked (int __c) ;





extern int getw (FILE *__stream) ;


extern int putw (int __w, FILE *__stream) ;





extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;



extern char *gets (char *__s) ;

# 477 "/usr/include/stdio.h" 3


extern int fputs (__const char *__restrict __s, FILE *__restrict __stream)
     ;


extern int puts (__const char *__s) ;



extern int ungetc (int __c, FILE *__stream) ;



extern size_t fread (void *__restrict __ptr, size_t __size,
                     size_t __n, FILE *__restrict __stream) ;

extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
                      size_t __n, FILE *__restrict __s) ;

# 506 "/usr/include/stdio.h" 3
extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
                              size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
                               size_t __n, FILE *__restrict __stream) ;





extern int fseek (FILE *__stream, long int __off, int __whence) ;

extern long int ftell (FILE *__stream) ;

extern void rewind (FILE *__stream) ;

# 546 "/usr/include/stdio.h" 3



extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos)
     ;

extern int fsetpos (FILE *__stream, __const fpos_t *__pos) ;
# 565 "/usr/include/stdio.h" 3

# 575 "/usr/include/stdio.h" 3


extern void clearerr (FILE *__stream) ;

extern int feof (FILE *__stream) ;

extern int ferror (FILE *__stream) ;




extern void clearerr_unlocked (FILE *__stream) ;
extern int feof_unlocked (FILE *__stream) ;
extern int ferror_unlocked (FILE *__stream) ;





extern void perror (__const char *__s) ;






# 1 "/usr/include/bits/sys_errlist.h" 1 3
# 27 "/usr/include/bits/sys_errlist.h" 3
extern int sys_nerr;
extern __const char *__const sys_errlist[];
# 602 "/usr/include/stdio.h" 2 3




extern int fileno (FILE *__stream) ;




extern int fileno_unlocked (FILE *__stream) ;






extern FILE *popen (__const char *__command, __const char *__modes) ;


extern int pclose (FILE *__stream) ;





extern char *ctermid (char *__s) ;
# 655 "/usr/include/stdio.h" 3
extern void flockfile (FILE *__stream) ;



extern int ftrylockfile (FILE *__stream) ;


extern void funlockfile (FILE *__stream) ;
# 676 "/usr/include/stdio.h" 3
# 1 "/usr/include/bits/stdio.h" 1 3
# 33 "/usr/include/bits/stdio.h" 3
extern __inline int
vprintf (__const char *__restrict __fmt, __gnuc_va_list __arg)
{
  return vfprintf (stdout, __fmt, __arg);
}


extern __inline int
getchar (void)
{
  return _IO_getc (stdin);
}




extern __inline int
getc_unlocked (FILE *__fp)
{
  return ((__fp)->_IO_read_ptr >= (__fp)->_IO_read_end ? __uflow (__fp) : *(unsigned char *) (__fp)->_IO_read_ptr++);
}


extern __inline int
getchar_unlocked (void)
{
  return ((stdin)->_IO_read_ptr >= (stdin)->_IO_read_end ? __uflow (stdin) : *(unsigned char *) (stdin)->_IO_read_ptr++);
}




extern __inline int
putchar (int __c)
{
  return _IO_putc (__c, stdout);
}




extern __inline int
fputc_unlocked (int __c, FILE *__stream)
{
  return (((__stream)->_IO_write_ptr >= (__stream)->_IO_write_end) ? __overflow (__stream, (unsigned char) (__c)) : (unsigned char) (*(__stream)->_IO_write_ptr++ = (__c)));
}





extern __inline int
putc_unlocked (int __c, FILE *__stream)
{
  return (((__stream)->_IO_write_ptr >= (__stream)->_IO_write_end) ? __overflow (__stream, (unsigned char) (__c)) : (unsigned char) (*(__stream)->_IO_write_ptr++ = (__c)));
}


extern __inline int
putchar_unlocked (int __c)
{
  return (((stdout)->_IO_write_ptr >= (stdout)->_IO_write_end) ? __overflow (stdout, (unsigned char) (__c)) : (unsigned char) (*(stdout)->_IO_write_ptr++ = (__c)));
}
# 111 "/usr/include/bits/stdio.h" 3
extern __inline int
feof_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x10) != 0);
}


extern __inline int
ferror_unlocked (FILE *__stream)
{
  return (((__stream)->_flags & 0x20) != 0);
}
# 677 "/usr/include/stdio.h" 2 3



# 11 "../../src/src/rijndael.c" 2
# 1 "/usr/include/stdlib.h" 1 3
# 33 "/usr/include/stdlib.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 34 "/usr/include/stdlib.h" 2 3


# 93 "/usr/include/stdlib.h" 3


typedef struct
  {
    int quot;
    int rem;
  } div_t;



typedef struct
  {
    long int quot;
    long int rem;
  } ldiv_t;



# 137 "/usr/include/stdlib.h" 3
extern size_t __ctype_get_mb_cur_max (void) ;




extern double atof (__const char *__nptr) __attribute__ ((__pure__));

extern int atoi (__const char *__nptr) __attribute__ ((__pure__));

extern long int atol (__const char *__nptr) __attribute__ ((__pure__));





__extension__ extern long long int atoll (__const char *__nptr)
     __attribute__ ((__pure__));





extern double strtod (__const char *__restrict __nptr,
                      char **__restrict __endptr) ;

# 174 "/usr/include/stdlib.h" 3


extern long int strtol (__const char *__restrict __nptr,
                        char **__restrict __endptr, int __base) ;

extern unsigned long int strtoul (__const char *__restrict __nptr,
                                  char **__restrict __endptr, int __base)
     ;




__extension__
extern long long int strtoq (__const char *__restrict __nptr,
                             char **__restrict __endptr, int __base) ;

__extension__
extern unsigned long long int strtouq (__const char *__restrict __nptr,
                                       char **__restrict __endptr, int __base)
     ;





__extension__
extern long long int strtoll (__const char *__restrict __nptr,
                              char **__restrict __endptr, int __base) ;

__extension__
extern unsigned long long int strtoull (__const char *__restrict __nptr,
                                        char **__restrict __endptr, int __base)
     ;

# 264 "/usr/include/stdlib.h" 3
extern double __strtod_internal (__const char *__restrict __nptr,
                                 char **__restrict __endptr, int __group)
     ;
extern float __strtof_internal (__const char *__restrict __nptr,
                                char **__restrict __endptr, int __group)
     ;
extern long double __strtold_internal (__const char *__restrict __nptr,
                                       char **__restrict __endptr,
                                       int __group) ;

extern long int __strtol_internal (__const char *__restrict __nptr,
                                   char **__restrict __endptr,
                                   int __base, int __group) ;



extern unsigned long int __strtoul_internal (__const char *__restrict __nptr,
                                             char **__restrict __endptr,
                                             int __base, int __group) ;




__extension__
extern long long int __strtoll_internal (__const char *__restrict __nptr,
                                         char **__restrict __endptr,
                                         int __base, int __group) ;



__extension__
extern unsigned long long int __strtoull_internal (__const char *
                                                   __restrict __nptr,
                                                   char **__restrict __endptr,
                                                   int __base, int __group)
     ;








extern __inline double
strtod (__const char *__restrict __nptr, char **__restrict __endptr)
{
  return __strtod_internal (__nptr, __endptr, 0);
}
extern __inline long int
strtol (__const char *__restrict __nptr, char **__restrict __endptr,
        int __base)
{
  return __strtol_internal (__nptr, __endptr, __base, 0);
}
extern __inline unsigned long int
strtoul (__const char *__restrict __nptr, char **__restrict __endptr,
         int __base)
{
  return __strtoul_internal (__nptr, __endptr, __base, 0);
}

# 343 "/usr/include/stdlib.h" 3
__extension__ extern __inline long long int
strtoq (__const char *__restrict __nptr, char **__restrict __endptr,
        int __base)
{
  return __strtoll_internal (__nptr, __endptr, __base, 0);
}
__extension__ extern __inline unsigned long long int
strtouq (__const char *__restrict __nptr, char **__restrict __endptr,
         int __base)
{
  return __strtoull_internal (__nptr, __endptr, __base, 0);
}




__extension__ extern __inline long long int
strtoll (__const char *__restrict __nptr, char **__restrict __endptr,
         int __base)
{
  return __strtoll_internal (__nptr, __endptr, __base, 0);
}
__extension__ extern __inline unsigned long long int
strtoull (__const char * __restrict __nptr, char **__restrict __endptr,
          int __base)
{
  return __strtoull_internal (__nptr, __endptr, __base, 0);
}




extern __inline double
atof (__const char *__nptr)
{
  return strtod (__nptr, (char **) ((void *)0));
}
extern __inline int
atoi (__const char *__nptr)
{
  return (int) strtol (__nptr, (char **) ((void *)0), 10);
}
extern __inline long int
atol (__const char *__nptr)
{
  return strtol (__nptr, (char **) ((void *)0), 10);
}




__extension__ extern __inline long long int
atoll (__const char *__nptr)
{
  return strtoll (__nptr, (char **) ((void *)0), 10);
}

# 408 "/usr/include/stdlib.h" 3
extern char *l64a (long int __n) ;


extern long int a64l (__const char *__s) __attribute__ ((__pure__));


# 1 "/usr/include/sys/types.h" 1 3
# 28 "/usr/include/sys/types.h" 3






typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;



typedef __ino_t ino_t;
# 61 "/usr/include/sys/types.h" 3
typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;





typedef __off_t off_t;
# 99 "/usr/include/sys/types.h" 3
typedef __pid_t pid_t;




typedef __id_t id_t;




typedef __ssize_t ssize_t;





typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;
# 132 "/usr/include/sys/types.h" 3
# 1 "/usr/include/time.h" 1 3
# 74 "/usr/include/time.h" 3


typedef __time_t time_t;



# 92 "/usr/include/time.h" 3
typedef __clockid_t clockid_t;
# 104 "/usr/include/time.h" 3
typedef __timer_t timer_t;
# 133 "/usr/include/sys/types.h" 2 3
# 146 "/usr/include/sys/types.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 147 "/usr/include/sys/types.h" 2 3



typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
# 190 "/usr/include/sys/types.h" 3
typedef int int8_t __attribute__ ((__mode__ (__QI__)));
typedef int int16_t __attribute__ ((__mode__ (__HI__)));
typedef int int32_t __attribute__ ((__mode__ (__SI__)));
typedef int int64_t __attribute__ ((__mode__ (__DI__)));


typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));

typedef int register_t __attribute__ ((__mode__ (__word__)));
# 212 "/usr/include/sys/types.h" 3
# 1 "/usr/include/endian.h" 1 3
# 37 "/usr/include/endian.h" 3
# 1 "/usr/include/bits/endian.h" 1 3
# 38 "/usr/include/endian.h" 2 3
# 213 "/usr/include/sys/types.h" 2 3


# 1 "/usr/include/sys/select.h" 1 3
# 31 "/usr/include/sys/select.h" 3
# 1 "/usr/include/bits/select.h" 1 3
# 32 "/usr/include/sys/select.h" 2 3


# 1 "/usr/include/bits/sigset.h" 1 3
# 23 "/usr/include/bits/sigset.h" 3
typedef int __sig_atomic_t;




typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
# 35 "/usr/include/sys/select.h" 2 3



typedef __sigset_t sigset_t;





# 1 "/usr/include/time.h" 1 3
# 116 "/usr/include/time.h" 3
struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };
# 45 "/usr/include/sys/select.h" 2 3

# 1 "/usr/include/bits/time.h" 1 3
# 67 "/usr/include/bits/time.h" 3
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
# 47 "/usr/include/sys/select.h" 2 3


typedef __suseconds_t suseconds_t;





typedef long int __fd_mask;
# 67 "/usr/include/sys/select.h" 3
typedef struct
  {






    __fd_mask __fds_bits[1024 / (8 * sizeof (__fd_mask))];


  } fd_set;






typedef __fd_mask fd_mask;
# 99 "/usr/include/sys/select.h" 3







extern int select (int __nfds, fd_set *__restrict __readfds,
                   fd_set *__restrict __writefds,
                   fd_set *__restrict __exceptfds,
                   struct timeval *__restrict __timeout) ;
# 122 "/usr/include/sys/select.h" 3

# 216 "/usr/include/sys/types.h" 2 3


# 1 "/usr/include/sys/sysmacros.h" 1 3
# 219 "/usr/include/sys/types.h" 2 3
# 230 "/usr/include/sys/types.h" 3
typedef __blkcnt_t blkcnt_t;



typedef __fsblkcnt_t fsblkcnt_t;



typedef __fsfilcnt_t fsfilcnt_t;
# 262 "/usr/include/sys/types.h" 3

# 415 "/usr/include/stdlib.h" 2 3






extern long int random (void) ;


extern void srandom (unsigned int __seed) ;





extern char *initstate (unsigned int __seed, char *__statebuf,
                        size_t __statelen) ;



extern char *setstate (char *__statebuf) ;







struct random_data
  {
    int32_t *fptr;
    int32_t *rptr;
    int32_t *state;
    int rand_type;
    int rand_deg;
    int rand_sep;
    int32_t *end_ptr;
  };

extern int random_r (struct random_data *__restrict __buf,
                     int32_t *__restrict __result) ;

extern int srandom_r (unsigned int __seed, struct random_data *__buf) ;

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
                        size_t __statelen,
                        struct random_data *__restrict __buf) ;

extern int setstate_r (char *__restrict __statebuf,
                       struct random_data *__restrict __buf) ;






extern int rand (void) ;

extern void srand (unsigned int __seed) ;




extern int rand_r (unsigned int *__seed) ;







extern double drand48 (void) ;
extern double erand48 (unsigned short int __xsubi[3]) ;


extern long int lrand48 (void) ;
extern long int nrand48 (unsigned short int __xsubi[3]) ;


extern long int mrand48 (void) ;
extern long int jrand48 (unsigned short int __xsubi[3]) ;


extern void srand48 (long int __seedval) ;
extern unsigned short int *seed48 (unsigned short int __seed16v[3]) ;
extern void lcong48 (unsigned short int __param[7]) ;





struct drand48_data
  {
    unsigned short int __x[3];
    unsigned short int __old_x[3];
    unsigned short int __c;
    unsigned short int __init;
    unsigned long long int __a;
  };


extern int drand48_r (struct drand48_data *__restrict __buffer,
                      double *__restrict __result) ;
extern int erand48_r (unsigned short int __xsubi[3],
                      struct drand48_data *__restrict __buffer,
                      double *__restrict __result) ;


extern int lrand48_r (struct drand48_data *__restrict __buffer,
                      long int *__restrict __result) ;
extern int nrand48_r (unsigned short int __xsubi[3],
                      struct drand48_data *__restrict __buffer,
                      long int *__restrict __result) ;


extern int mrand48_r (struct drand48_data *__restrict __buffer,
                      long int *__restrict __result) ;
extern int jrand48_r (unsigned short int __xsubi[3],
                      struct drand48_data *__restrict __buffer,
                      long int *__restrict __result) ;


extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     ;

extern int seed48_r (unsigned short int __seed16v[3],
                     struct drand48_data *__buffer) ;

extern int lcong48_r (unsigned short int __param[7],
                      struct drand48_data *__buffer) ;









extern void *malloc (size_t __size) __attribute__ ((__malloc__));

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__malloc__));







extern void *realloc (void *__ptr, size_t __size) __attribute__ ((__malloc__));

extern void free (void *__ptr) ;




extern void cfree (void *__ptr) ;



# 1 "/usr/include/alloca.h" 1 3
# 25 "/usr/include/alloca.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 26 "/usr/include/alloca.h" 2 3







extern void *alloca (size_t __size) ;






# 577 "/usr/include/stdlib.h" 2 3




extern void *valloc (size_t __size) __attribute__ ((__malloc__));
# 590 "/usr/include/stdlib.h" 3


extern void abort (void) __attribute__ ((__noreturn__));



extern int atexit (void (*__func) (void)) ;





extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     ;






extern void exit (int __status) __attribute__ ((__noreturn__));

# 622 "/usr/include/stdlib.h" 3


extern char *getenv (__const char *__name) ;




extern char *__secure_getenv (__const char *__name) ;





extern int putenv (char *__string) ;





extern int setenv (__const char *__name, __const char *__value, int __replace)
     ;


extern int unsetenv (__const char *__name) ;






extern int clearenv (void) ;
# 661 "/usr/include/stdlib.h" 3
extern char *mktemp (char *__template) ;







extern int mkstemp (char *__template) ;
# 688 "/usr/include/stdlib.h" 3
extern char *mkdtemp (char *__template) ;





extern int system (__const char *__command) ;

# 712 "/usr/include/stdlib.h" 3
extern char *realpath (__const char *__restrict __name,
                       char *__restrict __resolved) ;






typedef int (*__compar_fn_t) (__const void *, __const void *);









extern void *bsearch (__const void *__key, __const void *__base,
                      size_t __nmemb, size_t __size, __compar_fn_t __compar);



extern void qsort (void *__base, size_t __nmemb, size_t __size,
                   __compar_fn_t __compar);



extern int abs (int __x) __attribute__ ((__const__));
extern long int labs (long int __x) __attribute__ ((__const__));












extern div_t div (int __numer, int __denom)
     __attribute__ ((__const__));
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__const__));

# 776 "/usr/include/stdlib.h" 3
extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
                   int *__restrict __sign) ;




extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
                   int *__restrict __sign) ;




extern char *gcvt (double __value, int __ndigit, char *__buf) ;




extern char *qecvt (long double __value, int __ndigit,
                    int *__restrict __decpt, int *__restrict __sign) ;
extern char *qfcvt (long double __value, int __ndigit,
                    int *__restrict __decpt, int *__restrict __sign) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf) ;




extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
                   int *__restrict __sign, char *__restrict __buf,
                   size_t __len) ;
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
                   int *__restrict __sign, char *__restrict __buf,
                   size_t __len) ;

extern int qecvt_r (long double __value, int __ndigit,
                    int *__restrict __decpt, int *__restrict __sign,
                    char *__restrict __buf, size_t __len) ;
extern int qfcvt_r (long double __value, int __ndigit,
                    int *__restrict __decpt, int *__restrict __sign,
                    char *__restrict __buf, size_t __len) ;







extern int mblen (__const char *__s, size_t __n) ;


extern int mbtowc (wchar_t *__restrict __pwc,
                   __const char *__restrict __s, size_t __n) ;


extern int wctomb (char *__s, wchar_t __wchar) ;



extern size_t mbstowcs (wchar_t *__restrict __pwcs,
                        __const char *__restrict __s, size_t __n) ;

extern size_t wcstombs (char *__restrict __s,
                        __const wchar_t *__restrict __pwcs, size_t __n)
     ;








extern int rpmatch (__const char *__response) ;
# 908 "/usr/include/stdlib.h" 3
extern int getloadavg (double __loadavg[], int __nelem) ;






# 12 "../../src/src/rijndael.c" 2

# 1 "../../src/src/rijndael.h" 1
# 16 "../../src/src/rijndael.h"
# 1 "../config.h" 1
# 17 "../../src/src/rijndael.h" 2

typedef unsigned char word8;


  typedef unsigned int word32;
# 30 "../../src/src/rijndael.h"
# 1 "../../src/src/tables.h" 1
extern word8 M0b[4][256][4];
extern word8 M1b[4][256][4];
extern word32 (*M0)[256];
extern word32 (*M1)[256];
extern word8 xrcon[30];
extern word8 xLogtable[256];
extern word8 xAlogtable[256];
extern word8 xS[256];
extern word8 xSi[256];
extern word8 L[256];
# 31 "../../src/src/rijndael.h" 2






typedef struct {
  int BC;
  int KC;
  int ROUNDS;
  int shift[2][4];
  word32 rk[((14 +1)*(256/32))];
} roundkey;
# 53 "../../src/src/rijndael.h"
int xrijndaelKeySched (word32 key[], int keyBits, int blockBits,
                       roundkey *rkk);







void xrijndaelEncrypt (word32 block[], roundkey *rkk);
void xrijndaelDecrypt (word32 block[], roundkey *rkk);
# 14 "../../src/src/rijndael.c" 2

static int xshifts[3][2][4] = {
  0,1,2,3,
  0,3,2,1,

  0,1,2,3,
  0,5,4,3,

  0,1,3,4,
  0,7,5,4,
};



void xKeyAddition(word8 res[(256/32)][4], word8 a[(256/32)][4],
                  word32 rk[(256/32)], word8 BC) {
  int j;

  for(j = 0; j < BC; j++)
    *(word32 *)res[j] = *(word32 *)a[j] ^ rk[j];
}



void xShiftRow(word8 res[(256/32)][4], word8 a[(256/32)][4], int shift[4],
               word8 BC)
{



  int i, j;
  int s;

  for (j=0; j < BC; j++) {
    res[j][0] = a[j][0];
  }
  for(i = 1; i < 4; i++) {
    s = shift[i];
    for(j = 0; j < BC; j++)
      res[j][i] = a[(j + s) % BC][i];
  }
}

void xSubstitution(word8 a[(256/32)][4], word8 box[256], word8 BC) {



  int i, j;

  for(i = 0; i < 4; i++)
    for(j = 0; j < BC; j++)
      a[j][i] = box[a[j][i]] ;
}
# 77 "../../src/src/rijndael.c"
void xShiftSubst(word8 res[(256/32)][4], word8 a[(256/32)][4], int shift[4],
                 word8 BC, word8 box[256]) {
  int i, j;
  int s;

  for (j=0; j < BC; j++) {
    res[j][0] = box[a[j][0]];
  }
  for(i = 1; i < 4; i++) {
    s = shift[i];
    for(j = 0; j < BC-s; j++)
      res[j][i] = box[a[(j + s)][i]];
    for(j = BC-s; j < BC; j++)
      res[j][i] = box[a[(j + s) - BC][i]];
  }
}



void xMixColumn(word8 res[(256/32)][4], word8 a[(256/32)][4], word8 BC) {
  int j;
  word32 b;

  for(j = 0; j < BC; j++) {
    b = M0[0][a[j][0]];
    b ^= M0[1][a[j][1]];
    b ^= M0[2][a[j][2]];
    b ^= M0[3][a[j][3]];
    *(word32 *)res[j] = b;
  }
}


void xMixAdd(word8 res[(256/32)][4], word8 a[(256/32)][4], word32 rk[(256/32)],
             word8 BC) {
  int j;
  word32 b;

  for(j = 0; j < BC; j++) {
    b = M0[0][a[j][0]];
    b ^= M0[1][a[j][1]];
    b ^= M0[2][a[j][2]];
    b ^= M0[3][a[j][3]];
    b ^= rk[j];
    *(word32 *)res[j] = b;
  }
}




void xInvMixColumn(word8 res[(256/32)][4], word8 a[(256/32)][4], word8 BC) {
  int j;
  word32 b;

  for(j = 0; j < BC; j++) {
    b = M1[0][a[j][0]];
    b ^= M1[1][a[j][1]];
    b ^= M1[2][a[j][2]];
    b ^= M1[3][a[j][3]];
    *(word32 *)res[j] = b;
  }
}


void xAddInvMix(word8 res[(256/32)][4], word8 a[(256/32)][4], word32 rk[(256/32)],
                  word8 BC) {
  int j;
  word32 b;

  for(j = 0; j < BC; j++) {
    *(word32 *)a[j] = *(word32 *)a[j] ^ rk[j];
    b = M1[0][a[j][0]];
    b ^= M1[1][a[j][1]];
    b ^= M1[2][a[j][2]];
    b ^= M1[3][a[j][3]];
    *(word32 *)res[j] = b;
  }
}

int xrijndaelKeySched (word32 key[], int keyBits, int blockBits,
                       roundkey *rkk) {


  int KC, BC, ROUNDS;
  int i, j, t, rconpointer = 0;
  word8 (*k)[4] = (word8 (*)[4])key;
  word32 *k32 = (word32 *)key;

  switch (keyBits) {
  case 128: KC = 4; break;
  case 192: KC = 6; break;
  case 256: KC = 8; break;
  default : return -1;
  }

  switch (blockBits) {
  case 128: BC = 4; break;
  case 192: BC = 6; break;
  case 256: BC = 8; break;
  default : return -2;
  }

  ROUNDS = KC>BC ? KC+6 : BC+6;

  t = 0;

  for(j = 0; (j < KC) && (t < (ROUNDS+1)*BC); j++, t++)
    rkk->rk[t] = k32[j];

  while (t < (ROUNDS+1)*BC) {

    for(i = 0; i < 4; i++)
      k[0][i] ^= xS[k[KC-1][(i+1)%4]];
    k[0][0] ^= xrcon[rconpointer++];

    if (KC != 8)
      for(j = 1; j < KC; j++)
        k32[j] ^= k32[j-1];
    else {
      for(j = 1; j < 4; j++)
        k32[j] ^= k32[j-1];
      for(i = 0; i < 4; i++)
        k[4][i] ^= xS[k[3][i]];
      for(j = 5; j < 8; j++)
        k32[j] ^= k32[j-1];
    }

    for(j = 0; (j < KC) && (t < (ROUNDS+1)*BC); j++, t++)
      rkk->rk[t] = k32[j];
  }


  rkk->BC = BC;
  rkk->KC = KC;
  rkk->ROUNDS = ROUNDS;
  for (i=0; i<2; i++)
    for (j=0; j<4; j++)
      rkk->shift[i][j] = xshifts[(BC-4) >> 1][i][j];

  return 0;
}



void xrijndaelEncrypt (word32 block[], roundkey *rkk)
{
  word8 (*a)[4] = (word8 (*)[4])block;
  word8 a2[(256/32)][4];
  int r;

  int *shift = rkk->shift[0];
  int BC = rkk->BC;
  int ROUNDS = rkk->ROUNDS;
  word32 *rp = rkk->rk;


  xKeyAddition(a,a,rp,BC);
  rp += BC;


  for(r = 1; r < ROUNDS; r++) {
    xShiftSubst(a2,a,shift,BC,xS);
    xMixAdd(a,a2,rp,BC);
    rp += BC;
  }


  xShiftSubst(a2,a,shift,BC,xS);
  xKeyAddition(a,a2,rp,BC);
}

void xrijndaelDecrypt (word32 block[], roundkey *rkk)
{
  word8 (*a)[4] = (word8 (*)[4])block;
  word8 a2[(256/32)][4];
  int r;

  int *shift = rkk->shift[1];
  int BC = rkk->BC;
  int ROUNDS = rkk->ROUNDS;
  word32 *rp = rkk->rk + ROUNDS*BC;
# 273 "../../src/src/rijndael.c"
  xKeyAddition(a2,a,rp,BC);
  xShiftSubst(a,a2,shift,BC,xSi);
  rp -= BC;



  for(r = ROUNDS-1; r > 0; r--) {
    xKeyAddition(a,a,rp,BC);
    xInvMixColumn(a2,a,BC);
    xShiftSubst(a,a2,shift,BC,xSi);
    rp -= BC;
  }




  xKeyAddition(a,a,rp,BC);
}

# 1 "../../src/src/unixcrypt.c"
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
# 1 "../../src/src/unixcrypt.c"
# 9 "../../src/src/unixcrypt.c"
# 1 "/usr/include/string.h" 1 3
# 26 "/usr/include/string.h" 3
# 1 "/usr/include/features.h" 1 3
# 291 "/usr/include/features.h" 3
# 1 "/usr/include/sys/cdefs.h" 1 3
# 292 "/usr/include/features.h" 2 3
# 320 "/usr/include/features.h" 3
# 1 "/usr/include/gnu/stubs.h" 1 3
# 321 "/usr/include/features.h" 2 3
# 27 "/usr/include/string.h" 2 3






# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 201 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef unsigned int size_t;
# 34 "/usr/include/string.h" 2 3




extern void *memcpy (void *__restrict __dest,
                     __const void *__restrict __src, size_t __n) ;


extern void *memmove (void *__dest, __const void *__src, size_t __n)
     ;






extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
                      int __c, size_t __n)
     ;





extern void *memset (void *__s, int __c, size_t __n) ;


extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__pure__));


extern void *memchr (__const void *__s, int __c, size_t __n)
      __attribute__ ((__pure__));

# 80 "/usr/include/string.h" 3


extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
     ;

extern char *strncpy (char *__restrict __dest,
                      __const char *__restrict __src, size_t __n) ;


extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
     ;

extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
                      size_t __n) ;


extern int strcmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__pure__));

extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__pure__));


extern int strcoll (__const char *__s1, __const char *__s2)
     __attribute__ ((__pure__));

extern size_t strxfrm (char *__restrict __dest,
                       __const char *__restrict __src, size_t __n) ;

# 160 "/usr/include/string.h" 3


extern char *strchr (__const char *__s, int __c) __attribute__ ((__pure__));

extern char *strrchr (__const char *__s, int __c) __attribute__ ((__pure__));











extern size_t strcspn (__const char *__s, __const char *__reject)
     __attribute__ ((__pure__));


extern size_t strspn (__const char *__s, __const char *__accept)
     __attribute__ ((__pure__));

extern char *strpbrk (__const char *__s, __const char *__accept)
     __attribute__ ((__pure__));

extern char *strstr (__const char *__haystack, __const char *__needle)
     __attribute__ ((__pure__));



extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
     ;




extern char *__strtok_r (char *__restrict __s,
                         __const char *__restrict __delim,
                         char **__restrict __save_ptr) ;

extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
                       char **__restrict __save_ptr) ;
# 228 "/usr/include/string.h" 3


extern size_t strlen (__const char *__s) __attribute__ ((__pure__));

# 241 "/usr/include/string.h" 3


extern char *strerror (int __errnum) ;

# 253 "/usr/include/string.h" 3
extern void __bzero (void *__s, size_t __n) ;
# 372 "/usr/include/string.h" 3
# 1 "/usr/include/bits/string.h" 1 3
# 373 "/usr/include/string.h" 2 3


# 1 "/usr/include/bits/string2.h" 1 3
# 52 "/usr/include/bits/string2.h" 3
# 1 "/usr/include/endian.h" 1 3
# 37 "/usr/include/endian.h" 3
# 1 "/usr/include/bits/endian.h" 1 3
# 38 "/usr/include/endian.h" 2 3
# 53 "/usr/include/bits/string2.h" 2 3
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
# 54 "/usr/include/bits/string2.h" 2 3
# 389 "/usr/include/bits/string2.h" 3
extern void *__rawmemchr (const void *__s, int __c);
# 919 "/usr/include/bits/string2.h" 3
extern __inline size_t __strcspn_c1 (__const char *__s, int __reject);
extern __inline size_t
__strcspn_c1 (__const char *__s, int __reject)
{
  register size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject)
    ++__result;
  return __result;
}

extern __inline size_t __strcspn_c2 (__const char *__s, int __reject1,
                                     int __reject2);
extern __inline size_t
__strcspn_c2 (__const char *__s, int __reject1, int __reject2)
{
  register size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject1
         && __s[__result] != __reject2)
    ++__result;
  return __result;
}

extern __inline size_t __strcspn_c3 (__const char *__s, int __reject1,
                                     int __reject2, int __reject3);
extern __inline size_t
__strcspn_c3 (__const char *__s, int __reject1, int __reject2,
              int __reject3)
{
  register size_t __result = 0;
  while (__s[__result] != '\0' && __s[__result] != __reject1
         && __s[__result] != __reject2 && __s[__result] != __reject3)
    ++__result;
  return __result;
}
# 976 "/usr/include/bits/string2.h" 3
extern __inline size_t __strspn_c1 (__const char *__s, int __accept);
extern __inline size_t
__strspn_c1 (__const char *__s, int __accept)
{
  register size_t __result = 0;

  while (__s[__result] == __accept)
    ++__result;
  return __result;
}

extern __inline size_t __strspn_c2 (__const char *__s, int __accept1,
                                    int __accept2);
extern __inline size_t
__strspn_c2 (__const char *__s, int __accept1, int __accept2)
{
  register size_t __result = 0;

  while (__s[__result] == __accept1 || __s[__result] == __accept2)
    ++__result;
  return __result;
}

extern __inline size_t __strspn_c3 (__const char *__s, int __accept1,
                                    int __accept2, int __accept3);
extern __inline size_t
__strspn_c3 (__const char *__s, int __accept1, int __accept2, int __accept3)
{
  register size_t __result = 0;

  while (__s[__result] == __accept1 || __s[__result] == __accept2
         || __s[__result] == __accept3)
    ++__result;
  return __result;
}
# 1033 "/usr/include/bits/string2.h" 3
extern __inline char *__strpbrk_c2 (__const char *__s, int __accept1,
                                     int __accept2);
extern __inline char *
__strpbrk_c2 (__const char *__s, int __accept1, int __accept2)
{

  while (*__s != '\0' && *__s != __accept1 && *__s != __accept2)
    ++__s;
  return *__s == '\0' ? ((void *)0) : (char *) (size_t) __s;
}

extern __inline char *__strpbrk_c3 (__const char *__s, int __accept1,
                                     int __accept2, int __accept3);
extern __inline char *
__strpbrk_c3 (__const char *__s, int __accept1, int __accept2,
              int __accept3)
{

  while (*__s != '\0' && *__s != __accept1 && *__s != __accept2
         && *__s != __accept3)
    ++__s;
  return *__s == '\0' ? ((void *)0) : (char *) (size_t) __s;
}
# 1085 "/usr/include/bits/string2.h" 3
extern __inline char *__strtok_r_1c (char *__s, char __sep, char **__nextp);
extern __inline char *
__strtok_r_1c (char *__s, char __sep, char **__nextp)
{
  char *__result;
  if (__s == ((void *)0))
    __s = *__nextp;
  while (*__s == __sep)
    ++__s;
  __result = ((void *)0);
  if (*__s != '\0')
    {
      __result = __s++;
      while (*__s != '\0')
        if (*__s++ == __sep)
          {
            __s[-1] = '\0';
            break;
          }
      *__nextp = __s;
    }
  return __result;
}
# 1117 "/usr/include/bits/string2.h" 3
extern char *__strsep_g (char **__stringp, __const char *__delim);
# 1135 "/usr/include/bits/string2.h" 3
extern __inline char *__strsep_1c (char **__s, char __reject);
extern __inline char *
__strsep_1c (char **__s, char __reject)
{
  register char *__retval = *__s;
  if (__retval != ((void *)0) && (*__s = (__extension__ (__builtin_constant_p (__reject) && (__reject) == '\0' ? (char *) __rawmemchr (__retval, __reject) : strchr (__retval, __reject)))) != ((void *)0))
    *(*__s)++ = '\0';
  return __retval;
}

extern __inline char *__strsep_2c (char **__s, char __reject1, char __reject2);
extern __inline char *
__strsep_2c (char **__s, char __reject1, char __reject2)
{
  register char *__retval = *__s;
  if (__retval != ((void *)0))
    {
      register char *__cp = __retval;
      while (1)
        {
          if (*__cp == '\0')
            {
              __cp = ((void *)0);
          break;
            }
          if (*__cp == __reject1 || *__cp == __reject2)
            {
              *__cp++ = '\0';
              break;
            }
          ++__cp;
        }
      *__s = __cp;
    }
  return __retval;
}

extern __inline char *__strsep_3c (char **__s, char __reject1, char __reject2,
                                   char __reject3);
extern __inline char *
__strsep_3c (char **__s, char __reject1, char __reject2, char __reject3)
{
  register char *__retval = *__s;
  if (__retval != ((void *)0))
    {
      register char *__cp = __retval;
      while (1)
        {
          if (*__cp == '\0')
            {
              __cp = ((void *)0);
          break;
            }
          if (*__cp == __reject1 || *__cp == __reject2 || *__cp == __reject3)
            {
              *__cp++ = '\0';
              break;
            }
          ++__cp;
        }
      *__s = __cp;
    }
  return __retval;
}
# 376 "/usr/include/string.h" 2 3




# 10 "../../src/src/unixcrypt.c" 2
# 1 "/usr/include/unistd.h" 1 3
# 28 "/usr/include/unistd.h" 3

# 175 "/usr/include/unistd.h" 3
# 1 "/usr/include/bits/posix_opt.h" 1 3
# 176 "/usr/include/unistd.h" 2 3
# 193 "/usr/include/unistd.h" 3
typedef __ssize_t ssize_t;





# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 200 "/usr/include/unistd.h" 2 3





typedef __gid_t gid_t;




typedef __uid_t uid_t;





typedef __off_t off_t;
# 228 "/usr/include/unistd.h" 3
typedef __useconds_t useconds_t;




typedef __pid_t pid_t;
# 247 "/usr/include/unistd.h" 3
typedef __socklen_t socklen_t;
# 260 "/usr/include/unistd.h" 3
extern int access (__const char *__name, int __type) ;
# 290 "/usr/include/unistd.h" 3
extern __off_t lseek (int __fd, __off_t __offset, int __whence) ;
# 306 "/usr/include/unistd.h" 3
extern int close (int __fd) ;



extern ssize_t read (int __fd, void *__buf, size_t __nbytes) ;


extern ssize_t write (int __fd, __const void *__buf, size_t __n) ;
# 353 "/usr/include/unistd.h" 3
extern int pipe (int __pipedes[2]) ;
# 362 "/usr/include/unistd.h" 3
extern unsigned int alarm (unsigned int __seconds) ;
# 371 "/usr/include/unistd.h" 3
extern unsigned int sleep (unsigned int __seconds) ;
# 389 "/usr/include/unistd.h" 3
extern int pause (void) ;



extern int chown (__const char *__file, __uid_t __owner, __gid_t __group)
     ;
# 409 "/usr/include/unistd.h" 3
extern int chdir (__const char *__path) ;
# 423 "/usr/include/unistd.h" 3
extern char *getcwd (char *__buf, size_t __size) ;
# 441 "/usr/include/unistd.h" 3
extern int dup (int __fd) ;


extern int dup2 (int __fd, int __fd2) ;


extern char **__environ;







extern int execve (__const char *__path, char *__const __argv[],
                   char *__const __envp[]) ;
# 467 "/usr/include/unistd.h" 3
extern int execv (__const char *__path, char *__const __argv[]) ;



extern int execle (__const char *__path, __const char *__arg, ...) ;



extern int execl (__const char *__path, __const char *__arg, ...) ;



extern int execvp (__const char *__file, char *__const __argv[]) ;




extern int execlp (__const char *__file, __const char *__arg, ...) ;




extern int nice (int __inc) ;




extern void _exit (int __status) __attribute__ ((__noreturn__));





# 1 "/usr/include/bits/confname.h" 1 3
# 25 "/usr/include/bits/confname.h" 3
enum
  {
    _PC_LINK_MAX,

    _PC_MAX_CANON,

    _PC_MAX_INPUT,

    _PC_NAME_MAX,

    _PC_PATH_MAX,

    _PC_PIPE_BUF,

    _PC_CHOWN_RESTRICTED,

    _PC_NO_TRUNC,

    _PC_VDISABLE,

    _PC_SYNC_IO,

    _PC_ASYNC_IO,

    _PC_PRIO_IO,

    _PC_SOCK_MAXBUF,

    _PC_FILESIZEBITS,

    _PC_REC_INCR_XFER_SIZE,

    _PC_REC_MAX_XFER_SIZE,

    _PC_REC_MIN_XFER_SIZE,

    _PC_REC_XFER_ALIGN,

    _PC_ALLOC_SIZE_MIN,

    _PC_SYMLINK_MAX

  };


enum
  {
    _SC_ARG_MAX,

    _SC_CHILD_MAX,

    _SC_CLK_TCK,

    _SC_NGROUPS_MAX,

    _SC_OPEN_MAX,

    _SC_STREAM_MAX,

    _SC_TZNAME_MAX,

    _SC_JOB_CONTROL,

    _SC_SAVED_IDS,

    _SC_REALTIME_SIGNALS,

    _SC_PRIORITY_SCHEDULING,

    _SC_TIMERS,

    _SC_ASYNCHRONOUS_IO,

    _SC_PRIORITIZED_IO,

    _SC_SYNCHRONIZED_IO,

    _SC_FSYNC,

    _SC_MAPPED_FILES,

    _SC_MEMLOCK,

    _SC_MEMLOCK_RANGE,

    _SC_MEMORY_PROTECTION,

    _SC_MESSAGE_PASSING,

    _SC_SEMAPHORES,

    _SC_SHARED_MEMORY_OBJECTS,

    _SC_AIO_LISTIO_MAX,

    _SC_AIO_MAX,

    _SC_AIO_PRIO_DELTA_MAX,

    _SC_DELAYTIMER_MAX,

    _SC_MQ_OPEN_MAX,

    _SC_MQ_PRIO_MAX,

    _SC_VERSION,

    _SC_PAGESIZE,


    _SC_RTSIG_MAX,

    _SC_SEM_NSEMS_MAX,

    _SC_SEM_VALUE_MAX,

    _SC_SIGQUEUE_MAX,

    _SC_TIMER_MAX,




    _SC_BC_BASE_MAX,

    _SC_BC_DIM_MAX,

    _SC_BC_SCALE_MAX,

    _SC_BC_STRING_MAX,

    _SC_COLL_WEIGHTS_MAX,

    _SC_EQUIV_CLASS_MAX,

    _SC_EXPR_NEST_MAX,

    _SC_LINE_MAX,

    _SC_RE_DUP_MAX,

    _SC_CHARCLASS_NAME_MAX,


    _SC_2_VERSION,

    _SC_2_C_BIND,

    _SC_2_C_DEV,

    _SC_2_FORT_DEV,

    _SC_2_FORT_RUN,

    _SC_2_SW_DEV,

    _SC_2_LOCALEDEF,


    _SC_PII,

    _SC_PII_XTI,

    _SC_PII_SOCKET,

    _SC_PII_INTERNET,

    _SC_PII_OSI,

    _SC_POLL,

    _SC_SELECT,

    _SC_UIO_MAXIOV,

    _SC_IOV_MAX = _SC_UIO_MAXIOV,

    _SC_PII_INTERNET_STREAM,

    _SC_PII_INTERNET_DGRAM,

    _SC_PII_OSI_COTS,

    _SC_PII_OSI_CLTS,

    _SC_PII_OSI_M,

    _SC_T_IOV_MAX,



    _SC_THREADS,

    _SC_THREAD_SAFE_FUNCTIONS,

    _SC_GETGR_R_SIZE_MAX,

    _SC_GETPW_R_SIZE_MAX,

    _SC_LOGIN_NAME_MAX,

    _SC_TTY_NAME_MAX,

    _SC_THREAD_DESTRUCTOR_ITERATIONS,

    _SC_THREAD_KEYS_MAX,

    _SC_THREAD_STACK_MIN,

    _SC_THREAD_THREADS_MAX,

    _SC_THREAD_ATTR_STACKADDR,

    _SC_THREAD_ATTR_STACKSIZE,

    _SC_THREAD_PRIORITY_SCHEDULING,

    _SC_THREAD_PRIO_INHERIT,

    _SC_THREAD_PRIO_PROTECT,

    _SC_THREAD_PROCESS_SHARED,


    _SC_NPROCESSORS_CONF,

    _SC_NPROCESSORS_ONLN,

    _SC_PHYS_PAGES,

    _SC_AVPHYS_PAGES,

    _SC_ATEXIT_MAX,

    _SC_PASS_MAX,


    _SC_XOPEN_VERSION,

    _SC_XOPEN_XCU_VERSION,

    _SC_XOPEN_UNIX,

    _SC_XOPEN_CRYPT,

    _SC_XOPEN_ENH_I18N,

    _SC_XOPEN_SHM,


    _SC_2_CHAR_TERM,

    _SC_2_C_VERSION,

    _SC_2_UPE,


    _SC_XOPEN_XPG2,

    _SC_XOPEN_XPG3,

    _SC_XOPEN_XPG4,


    _SC_CHAR_BIT,

    _SC_CHAR_MAX,

    _SC_CHAR_MIN,

    _SC_INT_MAX,

    _SC_INT_MIN,

    _SC_LONG_BIT,

    _SC_WORD_BIT,

    _SC_MB_LEN_MAX,

    _SC_NZERO,

    _SC_SSIZE_MAX,

    _SC_SCHAR_MAX,

    _SC_SCHAR_MIN,

    _SC_SHRT_MAX,

    _SC_SHRT_MIN,

    _SC_UCHAR_MAX,

    _SC_UINT_MAX,

    _SC_ULONG_MAX,

    _SC_USHRT_MAX,


    _SC_NL_ARGMAX,

    _SC_NL_LANGMAX,

    _SC_NL_MSGMAX,

    _SC_NL_NMAX,

    _SC_NL_SETMAX,

    _SC_NL_TEXTMAX,


    _SC_XBS5_ILP32_OFF32,

    _SC_XBS5_ILP32_OFFBIG,

    _SC_XBS5_LP64_OFF64,

    _SC_XBS5_LPBIG_OFFBIG,


    _SC_XOPEN_LEGACY,

    _SC_XOPEN_REALTIME,

    _SC_XOPEN_REALTIME_THREADS,


    _SC_ADVISORY_INFO,

    _SC_BARRIERS,

    _SC_BASE,

    _SC_C_LANG_SUPPORT,

    _SC_C_LANG_SUPPORT_R,

    _SC_CLOCK_SELECTION,

    _SC_CPUTIME,

    _SC_THREAD_CPUTIME,

    _SC_DEVICE_IO,

    _SC_DEVICE_SPECIFIC,

    _SC_DEVICE_SPECIFIC_R,

    _SC_FD_MGMT,

    _SC_FIFO,

    _SC_PIPE,

    _SC_FILE_ATTRIBUTES,

    _SC_FILE_LOCKING,

    _SC_FILE_SYSTEM,

    _SC_MONOTONIC_CLOCK,

    _SC_MULTI_PROCESS,

    _SC_SINGLE_PROCESS,

    _SC_NETWORKING,

    _SC_READER_WRITER_LOCKS,

    _SC_SPIN_LOCKS,

    _SC_REGEXP,

    _SC_REGEX_VERSION,

    _SC_SHELL,

    _SC_SIGNALS,

    _SC_SPAWN,

    _SC_SPORADIC_SERVER,

    _SC_THREAD_SPORADIC_SERVER,

    _SC_SYSTEM_DATABASE,

    _SC_SYSTEM_DATABASE_R,

    _SC_TIMEOUTS,

    _SC_TYPED_MEMORY_OBJECTS,

    _SC_USER_GROUPS,

    _SC_USER_GROUPS_R,

    _SC_2_PBS,

    _SC_2_PBS_ACCOUNTING,

    _SC_2_PBS_LOCATE,

    _SC_2_PBS_MESSAGE,

    _SC_2_PBS_TRACK,

    _SC_SYMLOOP_MAX,

    _SC_STREAMS,

    _SC_2_PBS_CHECKPOINT,


    _SC_V6_ILP32_OFF32,

    _SC_V6_ILP32_OFFBIG,

    _SC_V6_LP64_OFF64,

    _SC_V6_LPBIG_OFFBIG,


    _SC_HOST_NAME_MAX,

    _SC_TRACE,

    _SC_TRACE_EVENT_FILTER,

    _SC_TRACE_INHERIT,

    _SC_TRACE_LOG

  };





enum
  {
    _CS_PATH,
# 563 "/usr/include/bits/confname.h" 3
    _CS_V6_WIDTH_RESTRICTED_ENVS

  };
# 501 "/usr/include/unistd.h" 2 3


extern long int pathconf (__const char *__path, int __name) ;


extern long int fpathconf (int __fd, int __name) ;


extern long int sysconf (int __name) __attribute__ ((__const__));



extern size_t confstr (int __name, char *__buf, size_t __len) ;




extern __pid_t getpid (void) ;


extern __pid_t getppid (void) ;




extern __pid_t getpgrp (void) ;
# 536 "/usr/include/unistd.h" 3
extern __pid_t __getpgid (__pid_t __pid) ;
# 545 "/usr/include/unistd.h" 3
extern int setpgid (__pid_t __pid, __pid_t __pgid) ;
# 580 "/usr/include/unistd.h" 3
extern __pid_t setsid (void) ;







extern __uid_t getuid (void) ;


extern __uid_t geteuid (void) ;


extern __gid_t getgid (void) ;


extern __gid_t getegid (void) ;




extern int getgroups (int __size, __gid_t __list[]) ;
# 613 "/usr/include/unistd.h" 3
extern int setuid (__uid_t __uid) ;
# 630 "/usr/include/unistd.h" 3
extern int setgid (__gid_t __gid) ;
# 647 "/usr/include/unistd.h" 3
extern __pid_t fork (void) ;
# 660 "/usr/include/unistd.h" 3
extern char *ttyname (int __fd) ;



extern int ttyname_r (int __fd, char *__buf, size_t __buflen) ;



extern int isatty (int __fd) ;
# 679 "/usr/include/unistd.h" 3
extern int link (__const char *__from, __const char *__to) ;
# 693 "/usr/include/unistd.h" 3
extern int unlink (__const char *__name) ;


extern int rmdir (__const char *__path) ;



extern __pid_t tcgetpgrp (int __fd) ;


extern int tcsetpgrp (int __fd, __pid_t __pgrp_id) ;



extern char *getlogin (void) ;
# 726 "/usr/include/unistd.h" 3
# 1 "../../src/src/getopt.h" 1 3
# 47 "../../src/src/getopt.h" 3
extern char *optarg;
# 61 "../../src/src/getopt.h" 3
extern int optind;




extern int opterr;



extern int optopt;
# 145 "../../src/src/getopt.h" 3
extern int getopt (int __argc, char *const *__argv, const char *__shortopts);
# 727 "/usr/include/unistd.h" 2 3
# 741 "/usr/include/unistd.h" 3
extern int sethostname (__const char *__name, size_t __len) ;



extern int sethostid (long int __id) ;





extern int getdomainname (char *__name, size_t __len) ;
extern int setdomainname (__const char *__name, size_t __len) ;





extern int vhangup (void) ;


extern int revoke (__const char *__file) ;







extern int profil (unsigned short int *__sample_buffer, size_t __size,
                   size_t __offset, unsigned int __scale) ;





extern int acct (__const char *__name) ;



extern char *getusershell (void) ;
extern void endusershell (void) ;
extern void setusershell (void) ;





extern int daemon (int __nochdir, int __noclose) ;






extern int chroot (__const char *__path) ;



extern char *getpass (__const char *__prompt) ;





extern int fsync (int __fd) ;
# 946 "/usr/include/unistd.h" 3
extern char *crypt (__const char *__key, __const char *__salt) ;



extern void encrypt (char *__block, int __edflag) ;






extern void swab (__const void *__restrict __from, void *__restrict __to,
                  ssize_t __n) ;







extern char *ctermid (char *__s) ;
# 988 "/usr/include/unistd.h" 3

# 11 "../../src/src/unixcrypt.c" 2
# 1 "/usr/include/stdlib.h" 1 3
# 33 "/usr/include/stdlib.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 294 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef long int wchar_t;
# 34 "/usr/include/stdlib.h" 2 3








# 1 "/usr/include/bits/waitflags.h" 1 3
# 43 "/usr/include/stdlib.h" 2 3
# 1 "/usr/include/bits/waitstatus.h" 1 3
# 44 "/usr/include/stdlib.h" 2 3
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

# 157 "/usr/include/stdlib.h" 3


extern double strtod (__const char *__restrict __nptr,
                      char **__restrict __endptr) ;

# 174 "/usr/include/stdlib.h" 3


extern long int strtol (__const char *__restrict __nptr,
                        char **__restrict __endptr, int __base) ;

extern unsigned long int strtoul (__const char *__restrict __nptr,
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

# 374 "/usr/include/stdlib.h" 3

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

# 469 "/usr/include/stdlib.h" 3


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
# 552 "/usr/include/stdlib.h" 3


extern void *malloc (size_t __size) __attribute__ ((__malloc__));

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__malloc__));







extern void *realloc (void *__ptr, size_t __size) __attribute__ ((__malloc__));

extern void free (void *__ptr) ;

# 590 "/usr/include/stdlib.h" 3


extern void abort (void) __attribute__ ((__noreturn__));



extern int atexit (void (*__func) (void)) ;

# 606 "/usr/include/stdlib.h" 3




extern void exit (int __status) __attribute__ ((__noreturn__));

# 622 "/usr/include/stdlib.h" 3


extern char *getenv (__const char *__name) ;




extern char *__secure_getenv (__const char *__name) ;





extern int putenv (char *__string) ;
# 692 "/usr/include/stdlib.h" 3


extern int system (__const char *__command) ;

# 720 "/usr/include/stdlib.h" 3
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

# 819 "/usr/include/stdlib.h" 3



extern int mblen (__const char *__s, size_t __n) ;


extern int mbtowc (wchar_t *__restrict __pwc,
                   __const char *__restrict __s, size_t __n) ;


extern int wctomb (char *__s, wchar_t __wchar) ;



extern size_t mbstowcs (wchar_t *__restrict __pwcs,
                        __const char *__restrict __s, size_t __n) ;

extern size_t wcstombs (char *__restrict __s,
                        __const wchar_t *__restrict __pwcs, size_t __n)
     ;

# 866 "/usr/include/stdlib.h" 3
extern void setkey (__const char *__key) ;
# 882 "/usr/include/stdlib.h" 3
extern int grantpt (int __fd) ;



extern int unlockpt (int __fd) ;




extern char *ptsname (int __fd) ;
# 914 "/usr/include/stdlib.h" 3

# 12 "../../src/src/unixcrypt.c" 2
# 1 "/usr/include/errno.h" 1 3
# 32 "/usr/include/errno.h" 3




# 1 "/usr/include/bits/errno.h" 1 3
# 25 "/usr/include/bits/errno.h" 3
# 1 "/usr/include/linux/errno.h" 1 3



# 1 "/usr/include/asm/errno.h" 1 3
# 5 "/usr/include/linux/errno.h" 2 3
# 26 "/usr/include/bits/errno.h" 2 3
# 38 "/usr/include/bits/errno.h" 3
extern int *__errno_location (void) __attribute__ ((__const__));
# 37 "/usr/include/errno.h" 2 3
# 59 "/usr/include/errno.h" 3

# 13 "../../src/src/unixcrypt.c" 2

# 1 "../config.h" 1
# 15 "../../src/src/unixcrypt.c" 2
# 1 "../../src/src/unixcrypt.h" 1
# 11 "../../src/src/unixcrypt.h"
# 1 "/usr/include/stdio.h" 1 3
# 30 "/usr/include/stdio.h" 3




# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 35 "/usr/include/stdio.h" 2 3
# 44 "/usr/include/stdio.h" 3


typedef struct _IO_FILE FILE;





# 62 "/usr/include/stdio.h" 3
typedef struct _IO_FILE __FILE;
# 72 "/usr/include/stdio.h" 3
# 1 "/usr/include/libio.h" 1 3
# 32 "/usr/include/libio.h" 3
# 1 "/usr/include/_G_config.h" 1 3
# 14 "/usr/include/_G_config.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
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




typedef __gnuc_va_list va_list;
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

# 195 "/usr/include/stdio.h" 3
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__malloc__));





extern int fclose (FILE *__stream) ;

extern int fflush (FILE *__stream) ;

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

# 295 "/usr/include/stdio.h" 3


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
# 406 "/usr/include/stdio.h" 3


extern int fputc (int __c, FILE *__stream) ;
extern int putc (int __c, FILE *__stream) ;


extern int putchar (int __c) ;

# 426 "/usr/include/stdio.h" 3
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

# 513 "/usr/include/stdio.h" 3


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

# 592 "/usr/include/stdio.h" 3


extern void perror (__const char *__s) ;






# 1 "/usr/include/bits/sys_errlist.h" 1 3
# 602 "/usr/include/stdio.h" 2 3




extern int fileno (FILE *__stream) ;
# 618 "/usr/include/stdio.h" 3
extern FILE *popen (__const char *__command, __const char *__modes) ;


extern int pclose (FILE *__stream) ;





extern char *ctermid (char *__s) ;





extern char *cuserid (char *__s) ;
# 655 "/usr/include/stdio.h" 3
extern void flockfile (FILE *__stream) ;



extern int ftrylockfile (FILE *__stream) ;


extern void funlockfile (FILE *__stream) ;







# 1 "../../src/src/getopt.h" 1 3
# 47 "../../src/src/getopt.h" 3
extern char *optarg;
# 61 "../../src/src/getopt.h" 3
extern int optind;




extern int opterr;



extern int optopt;
# 145 "../../src/src/getopt.h" 3
extern int getopt (int __argc, char *const *__argv, const char *__shortopts);
# 671 "/usr/include/stdio.h" 2 3





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
# 84 "/usr/include/bits/stdio.h" 3
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
# 677 "/usr/include/stdio.h" 2 3



# 12 "../../src/src/unixcrypt.h" 2


struct unixcrypt_state_s {
  char box1[0x100];
  char box2[0x100];
  char box3[0x100];
  int j;
  int k;
};
typedef struct unixcrypt_state_s unixcrypt_state;

void unixcrypt_init(unixcrypt_state *st, char *key);
int unixcrypt_char(unixcrypt_state *st, int c);
int unixcrypt_file(int fd, char *filename, char *keyword);
int unixcrypt_streams(FILE *fin, FILE *fout, char *keyword);
# 16 "../../src/src/unixcrypt.c" 2
# 1 "../../src/src/io.h" 1
# 9 "../../src/src/io.h"
typedef struct reader {
  int (*bgetc)(struct reader *this);
} reader;


typedef struct writer {
  int (*dummy)();
  int (*bputc)(int c, struct writer *this);
  int (*beof)(struct writer *this);
} writer;






typedef struct readwriter {
  int (*bgetc)(struct reader *this);
  int (*bputc)(int c, struct writer *this);
  int (*beof)(struct writer *this);
} readwriter;


reader *new_stream_reader(FILE *in);
writer *new_stream_writer(FILE *out);
reader *new_reader(int fd);
writer *new_writer(int fd);


readwriter *new_file_readwriter(int fd, char *filename);


readwriter *new_pipe_readwriter();
# 17 "../../src/src/unixcrypt.c" 2
# 34 "../../src/src/unixcrypt.c"
char *crypt_sun(const char *key, const char *salt) {
  char salt1[2];
  static char result[13];
  char *p;
  int tmp;

  tmp = 0x3f & ((salt[0])>'Z'?(salt[0]-59):(salt[0])>'9'?((salt[0])-53):(salt[0])-'.');
  salt1[0] = ((tmp)>=38?((tmp)-38+'a'):(tmp)>=12?((tmp)-12+'A'):(tmp)+'.');
  tmp = 0x3f & ((salt[1])>'Z'?(salt[1]-59):(salt[1])>'9'?((salt[1])-53):(salt[1])-'.');
  salt1[1] = ((tmp)>=38?((tmp)-38+'a'):(tmp)>=12?((tmp)-12+'A'):(tmp)+'.');

  p = crypt(key, salt1);
  (__extension__ (__builtin_constant_p (p) && __builtin_constant_p (13) ? (strlen (p) + 1 >= ((size_t) (13)) ? (char *) memcpy (result, p, 13) : strncpy (result, p, 13)) : strncpy (result, p, 13)));

  result[0] = salt[0];
  result[1] = salt[1];

  return result;
}



void unixcrypt_init(unixcrypt_state *st, char *key) {
  signed char buf[16];
  int i, j, k, acc, tmp, v;
  char *p;

  (__extension__ (__builtin_constant_p (16) && (16) <= 16 ? ((16) == 1 ? ({ void *__s = (buf); *((__uint8_t *) __s) = (__uint8_t) 0; __s; }) : ({ void *__s = (buf); union { unsigned int __ui; unsigned short int __usi; unsigned char __uc; } *__u = __s; __uint8_t __c = (__uint8_t) (0); switch ((unsigned int) (16)) { case 15: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 11: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 7: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 3: __u->__usi = (unsigned short int) __c * 0x0101; __u = __extension__ ((void *) __u + 2); __u->__uc = (unsigned char) __c; break; case 14: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 10: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 6: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 2: __u->__usi = (unsigned short int) __c * 0x0101; break; case 13: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 9: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 5: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 1: __u->__uc = (unsigned char) __c; break; case 16: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 12: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 8: __u->__ui = __c * 0x01010101; __u = __extension__ ((void *) __u + 4); case 4: __u->__ui = __c * 0x01010101; case 0: break; } __s; })) : (__builtin_constant_p (0) && (0) == '\0' ? ({ void *__s = (buf); __builtin_memset (__s, '\0', 16); __s; }) : memset (buf, 0, 16))));
  (__extension__ (__builtin_constant_p (key) && __builtin_constant_p (8) ? (strlen (key) + 1 >= ((size_t) (8)) ? (char *) memcpy (buf, key, 8) : strncpy (buf, key, 8)) : strncpy (buf, key, 8)));

  buf[8] = buf[0];
  buf[9] = buf[1];
  p = crypt_sun(buf, &buf[8]);

  (__extension__ (__builtin_constant_p (p) && __builtin_constant_p (13) ? (strlen (p) + 1 >= ((size_t) (13)) ? (char *) memcpy (buf, p, 13) : strncpy (buf, p, 13)) : strncpy (buf, p, 13)));

  acc = 0x7b;

  for (i=0; i<13; i++) {
    acc = i + acc * buf[i];
  }

  for (i = 0; i < 0x100; i++) {
    st->box1[i] = i;
    st->box2[i] = 0;
  }

  for (i = 0; i < 0x100; i++) {
    acc *= 5;
    acc += buf[i % 13];

    v = acc - 0xfff1 * (acc / 0xfff1);

    j = (v & 0xff) % (0x100-i);
    k = 0xff - i;

    tmp = st->box1[k];
    st->box1[k] = st->box1[j];
    st->box1[j] = tmp;

    if (st->box2[k]==0) {
      j = ((v >> 8) & 0xff) % k;

      while (st->box2[j] != 0) {
        j = (j+1) % k;
      }

      st->box2[k] = j;
      st->box2[j] = k;
    }
  }


  for (i = 0; i < 0x100; i++) {
    st->box3[st->box1[i] & 0xff] = i;
  }


  st->j = st->k = 0;
}



int unixcrypt_char(unixcrypt_state *st, int c) {
  c += st->k;
  c = st->box1[c & 0xff];
  c += st->j;
  c = st->box2[c & 0xff];
  c -= st->j;
  c = st->box3[c & 0xff];
  c -= st->k;

  st->k++;
  if (st->k == 0x100) {
    st->j++;
    st->k = 0;
    if (st->j == 0x100) {
      st->j = 0;
    }
  }
  return c;
}



int unixcrypt(reader *r, writer *w, char *keyword) {
  unixcrypt_state uc_state;
  int c;
  int st;


  unixcrypt_init(&uc_state, keyword);


  c = r->bgetc(r);
  while (c != (-1)) {
    c = unixcrypt_char(&uc_state, c);
    st = w->bputc(c, w);
    if (st<0) return -1;
    c = r->bgetc(r);
  }
  if ((*__errno_location ()))
    return -1;

  return w->beof(w);
}



int unixcrypt_file(int fd, char *filename, char *keyword) {
  readwriter *rw = new_file_readwriter(fd, filename);
  reader *r = (reader *)rw;
  writer *w = (writer *)rw;
  int st = unixcrypt(r, w, keyword);
  free(rw);
  return st;
}



int unixcrypt_streams(FILE *fin, FILE *fout, char *keyword) {
  reader *r = new_stream_reader(fin);
  writer *w = new_stream_writer(fout);
  int st = unixcrypt(r, w, keyword);
  free(r);
  free(w);
  return st;
}

# 1 "../../src/src/main.c"
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
# 1 "../../src/src/main.c"
# 15 "../../src/src/main.c"
# 1 "/usr/include/stdlib.h" 1 3
# 25 "/usr/include/stdlib.h" 3
# 1 "/usr/include/features.h" 1 3
# 291 "/usr/include/features.h" 3
# 1 "/usr/include/sys/cdefs.h" 1 3
# 292 "/usr/include/features.h" 2 3
# 320 "/usr/include/features.h" 3
# 1 "/usr/include/gnu/stubs.h" 1 3
# 321 "/usr/include/features.h" 2 3
# 26 "/usr/include/stdlib.h" 2 3







# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 201 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef unsigned int size_t;
# 294 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 3
typedef long int wchar_t;
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
# 31 "/usr/include/sys/types.h" 2 3



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






# 16 "../../src/src/main.c" 2
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



# 17 "../../src/src/main.c" 2
# 1 "/usr/include/string.h" 1 3
# 28 "/usr/include/string.h" 3





# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
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

# 126 "/usr/include/string.h" 3
extern char *strdup (__const char *__s) __attribute__ ((__malloc__));
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




extern char *strerror_r (int __errnum, char *__buf, size_t __buflen) ;




extern void __bzero (void *__s, size_t __n) ;



extern void bcopy (__const void *__src, void *__dest, size_t __n) ;


extern void bzero (void *__s, size_t __n) ;


extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__pure__));


extern char *index (__const char *__s, int __c) __attribute__ ((__pure__));


extern char *rindex (__const char *__s, int __c) __attribute__ ((__pure__));



extern int ffs (int __i) __attribute__ ((__const__));
# 287 "/usr/include/string.h" 3
extern int strcasecmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__pure__));


extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__pure__));
# 309 "/usr/include/string.h" 3
extern char *strsep (char **__restrict __stringp,
                     __const char *__restrict __delim) ;
# 372 "/usr/include/string.h" 3
# 1 "/usr/include/bits/string.h" 1 3
# 373 "/usr/include/string.h" 2 3


# 1 "/usr/include/bits/string2.h" 1 3
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
# 1216 "/usr/include/bits/string2.h" 3
extern char *__strdup (__const char *__string) __attribute__ ((__malloc__));
# 1235 "/usr/include/bits/string2.h" 3
extern char *__strndup (__const char *__string, size_t __n)
     __attribute__ ((__malloc__));
# 376 "/usr/include/string.h" 2 3




# 18 "../../src/src/main.c" 2
# 1 "../../src/src/getopt.h" 1
# 47 "../../src/src/getopt.h"
extern char *optarg;
# 61 "../../src/src/getopt.h"
extern int optind;




extern int opterr;



extern int optopt;
# 94 "../../src/src/getopt.h"
struct option
{

  const char *name;





  int has_arg;
  int *flag;
  int val;
};
# 145 "../../src/src/getopt.h"
extern int getopt (int __argc, char *const *__argv, const char *__shortopts);





extern int getopt_long (int __argc, char *const *__argv, const char *__shortopts,
                        const struct option *__longopts, int *__longind);
extern int getopt_long_only (int __argc, char *const *__argv,
                             const char *__shortopts,
                             const struct option *__longopts, int *__longind);


extern int _getopt_internal (int __argc, char *const *__argv,
                             const char *__shortopts,
                             const struct option *__longopts, int *__longind,
                             int __long_only);
# 19 "../../src/src/main.c" 2
# 1 "/usr/include/signal.h" 1 3
# 31 "/usr/include/signal.h" 3


# 1 "/usr/include/bits/sigset.h" 1 3
# 103 "/usr/include/bits/sigset.h" 3
extern int __sigismember (__const __sigset_t *, int);
extern int __sigaddset (__sigset_t *, int);
extern int __sigdelset (__sigset_t *, int);
# 117 "/usr/include/bits/sigset.h" 3
extern __inline int __sigismember (__const __sigset_t *__set, int __sig) { unsigned long int __mask = (((unsigned long int) 1) << (((__sig) - 1) % (8 * sizeof (unsigned long int)))); unsigned long int __word = (((__sig) - 1) / (8 * sizeof (unsigned long int))); return (__set->__val[__word] & __mask) ? 1 : 0; }
extern __inline int __sigaddset ( __sigset_t *__set, int __sig) { unsigned long int __mask = (((unsigned long int) 1) << (((__sig) - 1) % (8 * sizeof (unsigned long int)))); unsigned long int __word = (((__sig) - 1) / (8 * sizeof (unsigned long int))); return ((__set->__val[__word] |= __mask), 0); }
extern __inline int __sigdelset ( __sigset_t *__set, int __sig) { unsigned long int __mask = (((unsigned long int) 1) << (((__sig) - 1) % (8 * sizeof (unsigned long int)))); unsigned long int __word = (((__sig) - 1) / (8 * sizeof (unsigned long int))); return ((__set->__val[__word] &= ~__mask), 0); }
# 34 "/usr/include/signal.h" 2 3







typedef __sig_atomic_t sig_atomic_t;

# 58 "/usr/include/signal.h" 3
# 1 "/usr/include/bits/signum.h" 1 3
# 59 "/usr/include/signal.h" 2 3
# 73 "/usr/include/signal.h" 3
typedef void (*__sighandler_t) (int);




extern __sighandler_t __sysv_signal (int __sig, __sighandler_t __handler)
     ;
# 88 "/usr/include/signal.h" 3


extern __sighandler_t signal (int __sig, __sighandler_t __handler) ;
# 102 "/usr/include/signal.h" 3

# 114 "/usr/include/signal.h" 3
extern int kill (__pid_t __pid, int __sig) ;






extern int killpg (__pid_t __pgrp, int __sig) ;




extern int raise (int __sig) ;




extern __sighandler_t ssignal (int __sig, __sighandler_t __handler) ;
extern int gsignal (int __sig) ;




extern void psignal (int __sig, __const char *__s) ;
# 146 "/usr/include/signal.h" 3
extern int __sigpause (int __sig_or_mask, int __is_sig) ;




extern int sigpause (int __mask) ;
# 174 "/usr/include/signal.h" 3
extern int sigblock (int __mask) ;


extern int sigsetmask (int __mask) ;


extern int siggetmask (void) ;
# 194 "/usr/include/signal.h" 3
typedef __sighandler_t sig_t;







# 1 "/usr/include/time.h" 1 3
# 203 "/usr/include/signal.h" 2 3


# 1 "/usr/include/bits/siginfo.h" 1 3
# 25 "/usr/include/bits/siginfo.h" 3
# 1 "/usr/include/bits/wordsize.h" 1 3
# 26 "/usr/include/bits/siginfo.h" 2 3







typedef union sigval
  {
    int sival_int;
    void *sival_ptr;
  } sigval_t;
# 51 "/usr/include/bits/siginfo.h" 3
typedef struct siginfo
  {
    int si_signo;
    int si_errno;

    int si_code;

    union
      {
        int _pad[((128 / sizeof (int)) - 3)];


        struct
          {
            __pid_t si_pid;
            __uid_t si_uid;
          } _kill;


        struct
          {
            unsigned int _timer1;
            unsigned int _timer2;
          } _timer;


        struct
          {
            __pid_t si_pid;
            __uid_t si_uid;
            sigval_t si_sigval;
          } _rt;


        struct
          {
            __pid_t si_pid;
            __uid_t si_uid;
            int si_status;
            __clock_t si_utime;
            __clock_t si_stime;
          } _sigchld;


        struct
          {
            void *si_addr;
          } _sigfault;


        struct
          {
            long int si_band;
            int si_fd;
          } _sigpoll;
      } _sifields;
  } siginfo_t;
# 128 "/usr/include/bits/siginfo.h" 3
enum
{
  SI_ASYNCNL = -6,

  SI_SIGIO,

  SI_ASYNCIO,

  SI_MESGQ,

  SI_TIMER,

  SI_QUEUE,

  SI_USER,

  SI_KERNEL = 0x80

};



enum
{
  ILL_ILLOPC = 1,

  ILL_ILLOPN,

  ILL_ILLADR,

  ILL_ILLTRP,

  ILL_PRVOPC,

  ILL_PRVREG,

  ILL_COPROC,

  ILL_BADSTK

};


enum
{
  FPE_INTDIV = 1,

  FPE_INTOVF,

  FPE_FLTDIV,

  FPE_FLTOVF,

  FPE_FLTUND,

  FPE_FLTRES,

  FPE_FLTINV,

  FPE_FLTSUB

};


enum
{
  SEGV_MAPERR = 1,

  SEGV_ACCERR

};


enum
{
  BUS_ADRALN = 1,

  BUS_ADRERR,

  BUS_OBJERR

};


enum
{
  TRAP_BRKPT = 1,

  TRAP_TRACE

};


enum
{
  CLD_EXITED = 1,

  CLD_KILLED,

  CLD_DUMPED,

  CLD_TRAPPED,

  CLD_STOPPED,

  CLD_CONTINUED

};


enum
{
  POLL_IN = 1,

  POLL_OUT,

  POLL_MSG,

  POLL_ERR,

  POLL_PRI,

  POLL_HUP

};
# 271 "/usr/include/bits/siginfo.h" 3
struct __pthread_attr_s;

typedef struct sigevent
  {
    sigval_t sigev_value;
    int sigev_signo;
    int sigev_notify;

    union
      {
        int _pad[((64 / sizeof (int)) - 3)];

        struct
          {
            void (*_function) (sigval_t);
            struct __pthread_attr_s *_attribute;
          } _sigev_thread;
      } _sigev_un;
  } sigevent_t;






enum
{
  SIGEV_SIGNAL = 0,

  SIGEV_NONE,

  SIGEV_THREAD

};
# 206 "/usr/include/signal.h" 2 3



extern int sigemptyset (sigset_t *__set) ;


extern int sigfillset (sigset_t *__set) ;


extern int sigaddset (sigset_t *__set, int __signo) ;


extern int sigdelset (sigset_t *__set, int __signo) ;


extern int sigismember (__const sigset_t *__set, int __signo) ;
# 238 "/usr/include/signal.h" 3
# 1 "/usr/include/bits/sigaction.h" 1 3
# 25 "/usr/include/bits/sigaction.h" 3
struct sigaction
  {


    union
      {

        __sighandler_t sa_handler;

        void (*sa_sigaction) (int, siginfo_t *, void *);
      }
    __sigaction_handler;







    __sigset_t sa_mask;


    int sa_flags;


    void (*sa_restorer) (void);
  };
# 239 "/usr/include/signal.h" 2 3


extern int sigprocmask (int __how, __const sigset_t *__restrict __set,
                        sigset_t *__restrict __oset) ;



extern int sigsuspend (__const sigset_t *__set) ;


extern int sigaction (int __sig, __const struct sigaction *__restrict __act,
                      struct sigaction *__restrict __oact) ;


extern int sigpending (sigset_t *__set) ;



extern int sigwait (__const sigset_t *__restrict __set, int *__restrict __sig)
     ;



extern int sigwaitinfo (__const sigset_t *__restrict __set,
                        siginfo_t *__restrict __info) ;



extern int sigtimedwait (__const sigset_t *__restrict __set,
                         siginfo_t *__restrict __info,
                         __const struct timespec *__restrict __timeout)
     ;



extern int sigqueue (__pid_t __pid, int __sig, __const union sigval __val)
     ;
# 284 "/usr/include/signal.h" 3
extern __const char *__const _sys_siglist[64];
extern __const char *__const sys_siglist[64];


struct sigvec
  {
    __sighandler_t sv_handler;
    int sv_mask;

    int sv_flags;

  };
# 308 "/usr/include/signal.h" 3
extern int sigvec (int __sig, __const struct sigvec *__vec,
                   struct sigvec *__ovec) ;



# 1 "/usr/include/bits/sigcontext.h" 1 3
# 28 "/usr/include/bits/sigcontext.h" 3
# 1 "/usr/include/asm/sigcontext.h" 1 3
# 18 "/usr/include/asm/sigcontext.h" 3
struct _fpreg {
        unsigned short significand[4];
        unsigned short exponent;
};

struct _fpxreg {
        unsigned short significand[4];
        unsigned short exponent;
        unsigned short padding[3];
};

struct _xmmreg {
        unsigned long element[4];
};

struct _fpstate {

        unsigned long cw;
        unsigned long sw;
        unsigned long tag;
        unsigned long ipoff;
        unsigned long cssel;
        unsigned long dataoff;
        unsigned long datasel;
        struct _fpreg _st[8];
        unsigned short status;
        unsigned short magic;


        unsigned long _fxsr_env[6];
        unsigned long mxcsr;
        unsigned long reserved;
        struct _fpxreg _fxsr_st[8];
        struct _xmmreg _xmm[8];
        unsigned long padding[56];
};



struct sigcontext {
        unsigned short gs, __gsh;
        unsigned short fs, __fsh;
        unsigned short es, __esh;
        unsigned short ds, __dsh;
        unsigned long edi;
        unsigned long esi;
        unsigned long ebp;
        unsigned long esp;
        unsigned long ebx;
        unsigned long edx;
        unsigned long ecx;
        unsigned long eax;
        unsigned long trapno;
        unsigned long err;
        unsigned long eip;
        unsigned short cs, __csh;
        unsigned long eflags;
        unsigned long esp_at_signal;
        unsigned short ss, __ssh;
        struct _fpstate * fpstate;
        unsigned long oldmask;
        unsigned long cr2;
};
# 29 "/usr/include/bits/sigcontext.h" 2 3
# 314 "/usr/include/signal.h" 2 3


extern int sigreturn (struct sigcontext *__scp) ;
# 326 "/usr/include/signal.h" 3
extern int siginterrupt (int __sig, int __interrupt) ;

# 1 "/usr/include/bits/sigstack.h" 1 3
# 26 "/usr/include/bits/sigstack.h" 3
struct sigstack
  {
    void *ss_sp;
    int ss_onstack;
  };



enum
{
  SS_ONSTACK = 1,

  SS_DISABLE

};
# 50 "/usr/include/bits/sigstack.h" 3
typedef struct sigaltstack
  {
    void *ss_sp;
    int ss_flags;
    size_t ss_size;
  } stack_t;
# 329 "/usr/include/signal.h" 2 3







extern int sigstack (struct sigstack *__ss, struct sigstack *__oss) ;



extern int sigaltstack (__const struct sigaltstack *__restrict __ss,
                        struct sigaltstack *__restrict __oss) ;
# 364 "/usr/include/signal.h" 3
# 1 "/usr/include/bits/sigthread.h" 1 3
# 31 "/usr/include/bits/sigthread.h" 3
extern int pthread_sigmask (int __how,
                            __const __sigset_t *__restrict __newmask,
                            __sigset_t *__restrict __oldmask);


extern int pthread_kill (pthread_t __threadid, int __signo) ;
# 365 "/usr/include/signal.h" 2 3






extern int __libc_current_sigrtmin (void) ;

extern int __libc_current_sigrtmax (void) ;




# 20 "../../src/src/main.c" 2
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

# 21 "../../src/src/main.c" 2
# 1 "/usr/include/fcntl.h" 1 3
# 29 "/usr/include/fcntl.h" 3




# 1 "/usr/include/bits/fcntl.h" 1 3
# 136 "/usr/include/bits/fcntl.h" 3
struct flock
  {
    short int l_type;
    short int l_whence;

    __off_t l_start;
    __off_t l_len;




    __pid_t l_pid;
  };
# 34 "/usr/include/fcntl.h" 2 3
# 60 "/usr/include/fcntl.h" 3
extern int fcntl (int __fd, int __cmd, ...) ;





extern int open (__const char *__file, int __oflag, ...) ;
# 83 "/usr/include/fcntl.h" 3
extern int creat (__const char *__file, __mode_t __mode) ;
# 112 "/usr/include/fcntl.h" 3
extern int lockf (int __fd, int __cmd, __off_t __len) ;
# 165 "/usr/include/fcntl.h" 3

# 22 "../../src/src/main.c" 2
# 1 "/usr/include/unistd.h" 1 3
# 28 "/usr/include/unistd.h" 3

# 175 "/usr/include/unistd.h" 3
# 1 "/usr/include/bits/posix_opt.h" 1 3
# 176 "/usr/include/unistd.h" 2 3
# 199 "/usr/include/unistd.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 200 "/usr/include/unistd.h" 2 3
# 240 "/usr/include/unistd.h" 3
typedef __intptr_t intptr_t;






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






extern __useconds_t ualarm (__useconds_t __value, __useconds_t __interval)
     ;



extern int usleep (__useconds_t __useconds) ;





extern int pause (void) ;



extern int chown (__const char *__file, __uid_t __owner, __gid_t __group)
     ;



extern int fchown (int __fd, __uid_t __owner, __gid_t __group) ;




extern int lchown (__const char *__file, __uid_t __owner, __gid_t __group)
     ;




extern int chdir (__const char *__path) ;



extern int fchdir (int __fd) ;
# 423 "/usr/include/unistd.h" 3
extern char *getcwd (char *__buf, size_t __size) ;
# 436 "/usr/include/unistd.h" 3
extern char *getwd (char *__buf) ;




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
# 562 "/usr/include/unistd.h" 3
extern int setpgrp (void) ;
# 580 "/usr/include/unistd.h" 3
extern __pid_t setsid (void) ;







extern __uid_t getuid (void) ;


extern __uid_t geteuid (void) ;


extern __gid_t getgid (void) ;


extern __gid_t getegid (void) ;




extern int getgroups (int __size, __gid_t __list[]) ;
# 613 "/usr/include/unistd.h" 3
extern int setuid (__uid_t __uid) ;




extern int setreuid (__uid_t __ruid, __uid_t __euid) ;




extern int seteuid (__uid_t __uid) ;






extern int setgid (__gid_t __gid) ;




extern int setregid (__gid_t __rgid, __gid_t __egid) ;




extern int setegid (__gid_t __gid) ;






extern __pid_t fork (void) ;






extern __pid_t vfork (void) ;





extern char *ttyname (int __fd) ;



extern int ttyname_r (int __fd, char *__buf, size_t __buflen) ;



extern int isatty (int __fd) ;





extern int ttyslot (void) ;




extern int link (__const char *__from, __const char *__to) ;



extern int symlink (__const char *__from, __const char *__to) ;




extern int readlink (__const char *__restrict __path, char *__restrict __buf,
                     size_t __len) ;



extern int unlink (__const char *__name) ;


extern int rmdir (__const char *__path) ;



extern __pid_t tcgetpgrp (int __fd) ;


extern int tcsetpgrp (int __fd, __pid_t __pgrp_id) ;



extern char *getlogin (void) ;
# 717 "/usr/include/unistd.h" 3
extern int setlogin (__const char *__name) ;
# 734 "/usr/include/unistd.h" 3
extern int gethostname (char *__name, size_t __len) ;






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






extern long int gethostid (void) ;


extern void sync (void) ;




extern int getpagesize (void) __attribute__ ((__const__));




extern int truncate (__const char *__file, __off_t __length) ;
# 841 "/usr/include/unistd.h" 3
extern int ftruncate (int __fd, __off_t __length) ;
# 857 "/usr/include/unistd.h" 3
extern int getdtablesize (void) ;
# 866 "/usr/include/unistd.h" 3
extern int brk (void *__addr) ;





extern void *sbrk (intptr_t __delta) ;
# 887 "/usr/include/unistd.h" 3
extern long int syscall (long int __sysno, ...) ;
# 938 "/usr/include/unistd.h" 3
extern int fdatasync (int __fildes) ;
# 983 "/usr/include/unistd.h" 3
extern int pthread_atfork (void (*__prepare) (void),
                           void (*__parent) (void),
                           void (*__child) (void)) ;



# 23 "../../src/src/main.c" 2
# 1 "/usr/include/time.h" 1 3
# 30 "/usr/include/time.h" 3








# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 39 "/usr/include/time.h" 2 3



# 1 "/usr/include/bits/time.h" 1 3
# 40 "/usr/include/bits/time.h" 3
extern long int __sysconf (int);
# 43 "/usr/include/time.h" 2 3
# 58 "/usr/include/time.h" 3


typedef __clock_t clock_t;



# 127 "/usr/include/time.h" 3


struct tm
{
  int tm_sec;
  int tm_min;
  int tm_hour;
  int tm_mday;
  int tm_mon;
  int tm_year;
  int tm_wday;
  int tm_yday;
  int tm_isdst;


  long int tm_gmtoff;
  __const char *tm_zone;




};








struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };


struct sigevent;
# 176 "/usr/include/time.h" 3



extern clock_t clock (void) ;


extern time_t time (time_t *__timer) ;


extern double difftime (time_t __time1, time_t __time0)
     __attribute__ ((__const__));


extern time_t mktime (struct tm *__tp) ;





extern size_t strftime (char *__restrict __s, size_t __maxsize,
                        __const char *__restrict __format,
                        __const struct tm *__restrict __tp) ;

# 224 "/usr/include/time.h" 3



extern struct tm *gmtime (__const time_t *__timer) ;



extern struct tm *localtime (__const time_t *__timer) ;





extern struct tm *gmtime_r (__const time_t *__restrict __timer,
                            struct tm *__restrict __tp) ;



extern struct tm *localtime_r (__const time_t *__restrict __timer,
                               struct tm *__restrict __tp) ;





extern char *asctime (__const struct tm *__tp) ;


extern char *ctime (__const time_t *__timer) ;







extern char *asctime_r (__const struct tm *__restrict __tp,
                        char *__restrict __buf) ;


extern char *ctime_r (__const time_t *__restrict __timer,
                      char *__restrict __buf) ;




extern char *__tzname[2];
extern int __daylight;
extern long int __timezone;




extern char *tzname[2];



extern void tzset (void) ;



extern int daylight;
extern long int timezone;





extern int stime (__const time_t *__when) ;
# 307 "/usr/include/time.h" 3
extern time_t timegm (struct tm *__tp) ;


extern time_t timelocal (struct tm *__tp) ;


extern int dysize (int __year) __attribute__ ((__const__));





extern int nanosleep (__const struct timespec *__requested_time,
                      struct timespec *__remaining) ;



extern int clock_getres (clockid_t __clock_id, struct timespec *__res) ;


extern int clock_gettime (clockid_t __clock_id, struct timespec *__tp) ;


extern int clock_settime (clockid_t __clock_id, __const struct timespec *__tp)
     ;
# 345 "/usr/include/time.h" 3
extern int timer_create (clockid_t __clock_id,
                         struct sigevent *__restrict __evp,
                         timer_t *__restrict __timerid) ;


extern int timer_delete (timer_t __timerid) ;


extern int timer_settime (timer_t __timerid, int __flags,
                          __const struct itimerspec *__restrict __value,
                          struct itimerspec *__restrict __ovalue) ;


extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
     ;


extern int timer_getoverrun (timer_t __timerid) ;
# 397 "/usr/include/time.h" 3

# 24 "../../src/src/main.c" 2

# 1 "../config.h" 1
# 26 "../../src/src/main.c" 2
# 1 "../../src/src/main.h" 1
# 15 "../../src/src/main.h"
typedef struct {
  char *name;
  int verbose;
  int debug;
  char *keyword;
  char *keyword2;
  int mode;
  int filter;
  char *suffix;
  char *prompt;
  int recursive;
  int symlinks;
  int force;
  int mismatch;
  char **infiles;
  int count;
  char *keyfile;
  int timid;
} cmdline;

extern cmdline cmd;
extern int sigint_flag;
# 27 "../../src/src/main.c" 2
# 1 "../../src/src/readkey.h" 1






char *readkey();
# 28 "../../src/src/main.c" 2
# 1 "../../src/src/ccrypt.h" 1






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
# 8 "../../src/src/ccrypt.h" 2


int ccencrypt_streams(FILE *fin, FILE *fout, char *keyword);
int ccdecrypt_streams(FILE *fin, FILE *fout, char *keyword);
int cckeychange_streams(FILE *fin, FILE *fout, char *key_in, char *key_out);


int ccencrypt_file(int fd, char *filename, char *keyword);
int ccdecrypt_file(int fd, char *filename, char *keyword);
int cckeychange_file(int fd, char *filename, char *key_in, char *key_out);


const char *ccrypt_error(int st);
# 29 "../../src/src/main.c" 2
# 1 "../../src/src/traverse.h" 1







# 1 "/usr/include/sys/stat.h" 1 3
# 96 "/usr/include/sys/stat.h" 3


# 1 "/usr/include/bits/stat.h" 1 3
# 36 "/usr/include/bits/stat.h" 3
struct stat
  {
    __dev_t st_dev;
    unsigned short int __pad1;

    __ino_t st_ino;



    __mode_t st_mode;
    __nlink_t st_nlink;
    __uid_t st_uid;
    __gid_t st_gid;
    __dev_t st_rdev;
    unsigned short int __pad2;

    __off_t st_size;



    __blksize_t st_blksize;


    __blkcnt_t st_blocks;



    __time_t st_atime;
    unsigned long int __unused1;
    __time_t st_mtime;
    unsigned long int __unused2;
    __time_t st_ctime;
    unsigned long int __unused3;

    unsigned long int __unused4;
    unsigned long int __unused5;



  };
# 99 "/usr/include/sys/stat.h" 2 3
# 200 "/usr/include/sys/stat.h" 3
extern int stat (__const char *__restrict __file,
                 struct stat *__restrict __buf) ;



extern int fstat (int __fd, struct stat *__buf) ;
# 228 "/usr/include/sys/stat.h" 3
extern int lstat (__const char *__restrict __file,
                  struct stat *__restrict __buf) ;
# 249 "/usr/include/sys/stat.h" 3
extern int chmod (__const char *__file, __mode_t __mode) ;



extern int fchmod (int __fd, __mode_t __mode) ;





extern __mode_t umask (__mode_t __mask) ;
# 268 "/usr/include/sys/stat.h" 3
extern int mkdir (__const char *__path, __mode_t __mode) ;





extern int mknod (__const char *__path, __mode_t __mode, __dev_t __dev)
     ;




extern int mkfifo (__const char *__path, __mode_t __mode) ;
# 306 "/usr/include/sys/stat.h" 3
extern int __fxstat (int __ver, int __fildes, struct stat *__stat_buf) ;
extern int __xstat (int __ver, __const char *__filename,
                    struct stat *__stat_buf) ;
extern int __lxstat (int __ver, __const char *__filename,
                     struct stat *__stat_buf) ;
# 337 "/usr/include/sys/stat.h" 3
extern int __xmknod (int __ver, __const char *__path, __mode_t __mode,
                     __dev_t *__dev) ;




extern __inline__ int stat (__const char *__path,
                            struct stat *__statbuf)
{
  return __xstat (3, __path, __statbuf);
}


extern __inline__ int lstat (__const char *__path,
                             struct stat *__statbuf)
{
  return __lxstat (3, __path, __statbuf);
}


extern __inline__ int fstat (int __fd, struct stat *__statbuf)
{
  return __fxstat (3, __fd, __statbuf);
}


extern __inline__ int mknod (__const char *__path, __mode_t __mode,
                             __dev_t __dev)
{
  return __xmknod (1, __path, __mode, &__dev);
}
# 395 "/usr/include/sys/stat.h" 3

# 9 "../../src/src/traverse.h" 2
# 1 "/usr/include/dirent.h" 1 3
# 28 "/usr/include/dirent.h" 3

# 62 "/usr/include/dirent.h" 3
# 1 "/usr/include/bits/dirent.h" 1 3
# 23 "/usr/include/bits/dirent.h" 3
struct dirent
  {

    __ino_t d_ino;
    __off_t d_off;




    unsigned short int d_reclen;
    unsigned char d_type;
    char d_name[256];
  };
# 63 "/usr/include/dirent.h" 2 3
# 98 "/usr/include/dirent.h" 3
enum
  {
    DT_UNKNOWN = 0,

    DT_FIFO = 1,

    DT_CHR = 2,

    DT_DIR = 4,

    DT_BLK = 6,

    DT_REG = 8,

    DT_LNK = 10,

    DT_SOCK = 12,

    DT_WHT = 14

  };
# 128 "/usr/include/dirent.h" 3
typedef struct __dirstream DIR;



extern DIR *opendir (__const char *__name) ;



extern int closedir (DIR *__dirp) ;
# 146 "/usr/include/dirent.h" 3
extern struct dirent *readdir (DIR *__dirp) ;
# 163 "/usr/include/dirent.h" 3
extern int readdir_r (DIR *__restrict __dirp,
                      struct dirent *__restrict __entry,
                      struct dirent **__restrict __result) ;
# 186 "/usr/include/dirent.h" 3
extern void rewinddir (DIR *__dirp) ;





extern void seekdir (DIR *__dirp, long int __pos) ;


extern long int telldir (DIR *__dirp) ;





extern int dirfd (DIR *__dirp) ;







# 1 "/usr/include/bits/posix1_lim.h" 1 3
# 126 "/usr/include/bits/posix1_lim.h" 3
# 1 "/usr/include/bits/local_lim.h" 1 3
# 36 "/usr/include/bits/local_lim.h" 3
# 1 "/usr/include/linux/limits.h" 1 3
# 37 "/usr/include/bits/local_lim.h" 2 3
# 127 "/usr/include/bits/posix1_lim.h" 2 3
# 210 "/usr/include/dirent.h" 2 3
# 220 "/usr/include/dirent.h" 3
# 1 "/usr/lib/gcc-lib/i386-redhat-linux/3.2/include/stddef.h" 1 3
# 221 "/usr/include/dirent.h" 2 3






extern int scandir (__const char *__restrict __dir,
                    struct dirent ***__restrict __namelist,
                    int (*__selector) (__const struct dirent *),
                    int (*__cmp) (__const void *, __const void *)) ;
# 255 "/usr/include/dirent.h" 3
extern int alphasort (__const void *__e1, __const void *__e2)
     __attribute__ ((__pure__));
# 300 "/usr/include/dirent.h" 3
extern __ssize_t getdirentries (int __fd, char *__restrict __buf,
                                size_t __nbytes,
                                __off_t *__restrict __basep) ;
# 323 "/usr/include/dirent.h" 3

# 10 "../../src/src/traverse.h" 2

void reset_inodes(void);
void traverse_file(char *filename);
void traverse_files(char **filelist, int count);
# 30 "../../src/src/main.c" 2
# 1 "../../src/src/xalloc.h" 1
# 10 "../../src/src/xalloc.h"
void *xalloc(size_t size, char *myname);


void *xrealloc(void *p, size_t size, char *myname);


char *xreadline(FILE *fin, char *myname);
# 31 "../../src/src/main.c" 2
# 1 "../../src/src/unixcrypt.h" 1
# 14 "../../src/src/unixcrypt.h"
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
# 32 "../../src/src/main.c" 2

cmdline cmd;



void usage(FILE *fout) {
  fprintf(fout, """ccrypt"" ""1.2"". Secure encryption and decryption of files and streams.

Usage: ""ccrypt"" [mode] [options] [file...]
       ""ccencrypt"" [options] [file...]
       ""ccdecrypt"" [options] [file...]
       ""ccat"" [options] file...

Modes:
    -e, --encrypt          encrypt
    -d, --decrypt          decrypt
    -c, --cat              cat; decrypt files to stdout
    -x, --keychange        change key
    -u, --unixcrypt        decrypt old unix crypt files

Options:
    -h, --help             print this help message and exit
    -V, --version          print version info and exit
    -L, --license          print license info and exit
    -v, --verbose          print progress information to stderr
    -q, --quiet            run quietly; suppress warnings
    -f, --force            overwrite existing files without asking
    -m, --mismatch         allow decryption with non-matching key
    -E, --envvar var       read keyword from environment variable var (unsafe)
    -K, --key key          give keyword on command line (unsafe)
    -k, --keyfile file     read keyword(s) as first line(s) from file
    -S, --suffix .suf      use suffix .suf instead of default "".cpt""
    -P, --prompt prompt    use prompt instead of \"Enter key: \"
    -t, --timid            prompt twice for destructive encryption keys
    -r, --recursive        recurse through directories
    -R, --rec-symlinks     follow symbolic links as subdirectories
    -l, --symlinks         dereference symbolic links
    --                     end of options, filenames follow
");

}


void version(FILE *fout) {
  fprintf(fout,
  """ccrypt"" ""1.2"". Secure encryption and decryption of files and streams.\n"
  "Copyright (C) 2000-2001 Peter Selinger.\n"
  );
}

void license(FILE *fout) {
  fprintf(fout,
  """ccrypt"" ""1.2"". Secure encryption and decryption of files and streams.\n"
  "Copyright (C) 2000-2001 Peter Selinger.\n"
  "\n"
  "For the full text of the GNU General Public License, see the file\n"
  "COPYING distributed with this software.\n"
  "\n"
  "This program is free software; you can redistribute it and/or modify\n"
  "it under the terms of the GNU General Public License as published by\n"
  "the Free Software Foundation; either version 2 of the License, or\n"
  "(at your option) any later version.\n"
  "\n"
  "This program is distributed in the hope that it will be useful,\n"
  "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
  "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
  "GNU General Public License for more details.\n"
  "\n"
  "You should have received a copy of the GNU General Public License\n"
  "along with this program; if not, write to the Free Software\n"
  "Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.\n"
  );
}




void output_commandline(cmdline cmd, FILE *fout) {
  char *recursive[] = {"no", "dirs, not symlinks", "dirs and symlinks"};

  fprintf(fout, "\nCommand line:\n");
  fprintf(fout, "verbose = %s\n", cmd.verbose>0 ? "yes" : "no");
  fprintf(fout, "quiet = %s\n", cmd.verbose<0 ? "yes" : "no");
  fprintf(fout, "debug = %d\n", cmd.debug);
  fprintf(fout, "keyword = %s\n", cmd.keyword ? "(known)" : "(unknown)");
  fprintf(fout, "mode = %d\n", cmd.mode);
  fprintf(fout, "suffix = %s\n", cmd.suffix);
  fprintf(fout, "recursive = %s\n", recursive[cmd.recursive]);
  fprintf(fout, "symlinks = %s\n", cmd.symlinks ? "yes" : "no");
  fprintf(fout, "force = %s\n", cmd.force ? "yes" : "no");
  fprintf(fout, "filter = %s\n", cmd.filter ? "yes" : "no");
  fprintf(fout, "infiles:");
  while (cmd.count-->0)
    fprintf(fout, " %s", *(cmd.infiles++));
  fprintf(fout, "\n\n");
}

static struct option longopts[] = {
  {"encrypt", 0, 0, 'e'},
  {"decrypt", 0, 0, 'd'},
  {"cat", 0, 0, 'c'},
  {"keychange", 0, 0, 'x'},
  {"unixcrypt", 0, 0, 'u'},
  {"help", 0, 0, 'h'},
  {"version", 0, 0, 'V'},
  {"license", 0, 0, 'L'},
  {"verbose", 0, 0, 'v'},
  {"quiet", 0, 0, 'q'},
  {"debug", 0, 0, 'D'},
  {"force", 0, 0, 'f'},
  {"mismatch", 0, 0, 'm'},
  {"envvar", 1, 0, 'E'},
  {"key", 1, 0, 'K'},
  {"keyfile", 0, 0, 'k'},
  {"suffix", 1, 0, 'S'},
  {"prompt", 1, 0, 'P'},
  {"timid", 0, 0, 't'},
  {"recursive", 0, 0, 'r'},
  {"rec-symlinks", 0, 0, 'R'},
  {"symlinks", 0, 0, 'l'},
  {0, 0, 0, 0}
};

static char *shortopts = "edcxuhVLvqDfmE:K:k:S:P:trRl-";

cmdline read_commandline(int ac, char *av[]) {
  cmdline cmd;
  int c;
  char *p;


  cmd.verbose = 0;
  cmd.debug = 0;
  cmd.keyword = ((void *)0);
  cmd.keyword2 = ((void *)0);
  cmd.mode = 0;
  cmd.suffix = ".cpt";
  cmd.prompt = ((void *)0);
  cmd.recursive = 0;
  cmd.symlinks = 0;
  cmd.force = 0;
  cmd.mismatch = 0;
  cmd.filter = 1;
  cmd.infiles = ((void *)0);
  cmd.count = 0;
  cmd.keyfile = ((void *)0);
  cmd.timid = 0;


  cmd.name = strrchr(av[0], '/');
  cmd.name = cmd.name ? cmd.name+1 : av[0];

  if (!__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cmd.name) && __builtin_constant_p ("ccencrypt") && (__s1_len = strlen (cmd.name), __s2_len = strlen ("ccencrypt"), (!((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("ccencrypt") + 1) - (size_t)(const void *)("ccencrypt") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (cmd.name), (__const char *) ("ccencrypt"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) && (__s1_len = strlen (cmd.name), __s1_len < 4) ? (__builtin_constant_p ("ccencrypt") && ((size_t)(const void *)(("ccencrypt") + 1) - (size_t)(const void *)("ccencrypt") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccencrypt"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("ccencrypt"); register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("ccencrypt") && ((size_t)(const void *)(("ccencrypt") + 1) - (size_t)(const void *)("ccencrypt") == 1) && (__s2_len = strlen ("ccencrypt"), __s2_len < 4) ? (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccencrypt"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (cmd.name); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("ccencrypt"))[3]); } } __result; }))) : strcmp (cmd.name, "ccencrypt")))); })) {
    cmd.mode = 0;
  } else if (!__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cmd.name) && __builtin_constant_p ("ccdecrypt") && (__s1_len = strlen (cmd.name), __s2_len = strlen ("ccdecrypt"), (!((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("ccdecrypt") + 1) - (size_t)(const void *)("ccdecrypt") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (cmd.name), (__const char *) ("ccdecrypt"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) && (__s1_len = strlen (cmd.name), __s1_len < 4) ? (__builtin_constant_p ("ccdecrypt") && ((size_t)(const void *)(("ccdecrypt") + 1) - (size_t)(const void *)("ccdecrypt") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccdecrypt"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("ccdecrypt"); register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("ccdecrypt") && ((size_t)(const void *)(("ccdecrypt") + 1) - (size_t)(const void *)("ccdecrypt") == 1) && (__s2_len = strlen ("ccdecrypt"), __s2_len < 4) ? (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccdecrypt"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (cmd.name); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("ccdecrypt"))[3]); } } __result; }))) : strcmp (cmd.name, "ccdecrypt")))); })) {
    cmd.mode = 1;
  } else if (!__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cmd.name) && __builtin_constant_p ("ccat") && (__s1_len = strlen (cmd.name), __s2_len = strlen ("ccat"), (!((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("ccat") + 1) - (size_t)(const void *)("ccat") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (cmd.name), (__const char *) ("ccat"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) && (__s1_len = strlen (cmd.name), __s1_len < 4) ? (__builtin_constant_p ("ccat") && ((size_t)(const void *)(("ccat") + 1) - (size_t)(const void *)("ccat") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccat"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccat"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccat"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccat"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("ccat"); register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("ccat") && ((size_t)(const void *)(("ccat") + 1) - (size_t)(const void *)("ccat") == 1) && (__s2_len = strlen ("ccat"), __s2_len < 4) ? (__builtin_constant_p (cmd.name) && ((size_t)(const void *)((cmd.name) + 1) - (size_t)(const void *)(cmd.name) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.name))[0] - ((__const unsigned char *) (__const char *)("ccat"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[1] - ((__const unsigned char *) (__const char *) ("ccat"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.name))[2] - ((__const unsigned char *) (__const char *) ("ccat"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.name))[3] - ((__const unsigned char *) (__const char *) ("ccat"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (cmd.name); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("ccat"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("ccat"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("ccat"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("ccat"))[3]); } } __result; }))) : strcmp (cmd.name, "ccat")))); })) {
    cmd.mode = 3;
  } else {
    cmd.name = av[0] = "ccrypt";
  }

  while ((c = getopt_long(ac, av, shortopts, longopts, ((void *)0))) != -1) {
    switch (c) {
    case 'h':
      usage(stdout);
      exit(0);
      break;
    case 'V':
      version(stdout);
      exit(0);
      break;
    case 'L':
      license(stdout);
      exit(0);
      break;
    case 'v':
      cmd.verbose=1;
      break;
    case 'q':
      cmd.verbose=-1;
      break;
    case 'D':
      cmd.debug++;
      break;
    case 'E':
      p = getenv(optarg);
      if (p==((void *)0)) {
        fprintf(stderr, "%s: environment variable %s does not exist\n",
                cmd.name, optarg);
        exit(1);
      }
      cmd.keyword = (__extension__ (__builtin_constant_p (p) && ((size_t)(const void *)((p) + 1) - (size_t)(const void *)(p) == 1) ? (((__const char *) (p))[0] == '\0' ? (char *) calloc (1, 1) : ({ size_t __len = strlen (p) + 1; char *__retval = (char *) malloc (__len); if (__retval != ((void *)0)) __retval = (char *) memcpy (__retval, p, __len); __retval; })) : __strdup (p)));


      for (; *p; p++) {
        *p = 0;
      }
      break;
    case 'K':
      cmd.keyword = (__extension__ (__builtin_constant_p (optarg) && ((size_t)(const void *)((optarg) + 1) - (size_t)(const void *)(optarg) == 1) ? (((__const char *) (optarg))[0] == '\0' ? (char *) calloc (1, 1) : ({ size_t __len = strlen (optarg) + 1; char *__retval = (char *) malloc (__len); if (__retval != ((void *)0)) __retval = (char *) memcpy (__retval, optarg, __len); __retval; })) : __strdup (optarg)));


      for (p=optarg; *p; p++) {
        *p = 0;
      }
      break;
    case 'k':
      cmd.keyfile = optarg;
      break;
    case 'S':
      cmd.suffix = optarg;
      break;
    case 'P':
      cmd.prompt = optarg;
      break;
    case 'e':
      cmd.mode = 0;
      break;
    case 'd':
      cmd.mode = 1;
      break;
    case 'c':
      cmd.mode = 3;
      break;
    case 'x':
      cmd.mode = 2;
      break;
    case 'u':
      cmd.mode = 4;
      break;
    case 't':
      cmd.timid = 1;
      break;
    case 'r':
      cmd.recursive = 1;
      break;
    case 'R':
      cmd.recursive = 2;
      break;
    case 'l':
      cmd.symlinks = 1;
      break;
    case 'f':
      cmd.force = 1;
      break;
    case 'm':
      cmd.mismatch = 1;
      break;
    case '?':
      fprintf(stderr, "Try --help for more info\n");
      exit(1);
      break;

    }
  }

  cmd.infiles = &av[optind];
  cmd.count = ac-optind;




  if (cmd.count > 0 || __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (av[optind-1]) && __builtin_constant_p ("--") && (__s1_len = strlen (av[optind-1]), __s2_len = strlen ("--"), (!((size_t)(const void *)((av[optind-1]) + 1) - (size_t)(const void *)(av[optind-1]) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("--") + 1) - (size_t)(const void *)("--") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (av[optind-1]), (__const char *) ("--"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (av[optind-1]) && ((size_t)(const void *)((av[optind-1]) + 1) - (size_t)(const void *)(av[optind-1]) == 1) && (__s1_len = strlen (av[optind-1]), __s1_len < 4) ? (__builtin_constant_p ("--") && ((size_t)(const void *)(("--") + 1) - (size_t)(const void *)("--") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[0] - ((__const unsigned char *) (__const char *)("--"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[1] - ((__const unsigned char *) (__const char *) ("--"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[2] - ((__const unsigned char *) (__const char *) ("--"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[3] - ((__const unsigned char *) (__const char *) ("--"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("--"); register int __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("--") && ((size_t)(const void *)(("--") + 1) - (size_t)(const void *)("--") == 1) && (__s2_len = strlen ("--"), __s2_len < 4) ? (__builtin_constant_p (av[optind-1]) && ((size_t)(const void *)((av[optind-1]) + 1) - (size_t)(const void *)(av[optind-1]) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[0] - ((__const unsigned char *) (__const char *)("--"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[1] - ((__const unsigned char *) (__const char *) ("--"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[2] - ((__const unsigned char *) (__const char *) ("--"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (av[optind-1]))[3] - ((__const unsigned char *) (__const char *) ("--"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (av[optind-1]); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("--"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("--"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("--"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("--"))[3]); } } __result; }))) : strcmp (av[optind-1], "--")))); })==0) {
    cmd.filter = 0;
  }


  if (cmd.mode == 3) {
    cmd.symlinks = 1;
  }

  if (cmd.debug) {
    output_commandline(cmd, stderr);
  }




  if (cmd.mismatch && !cmd.filter && cmd.mode!=3) {
    fprintf(stderr, "%s: option -m can only be used with -c or when running as a filter.\n", cmd.name);
    exit(1);
  }


  if (!cmd.filter && cmd.count==0) {
    if (cmd.verbose>=0)
      fprintf(stderr, "%s: warning: empty list of filenames given\n", cmd.name);
    exit(0);
  }



  if (cmd.filter && !cmd.force) {
    if ((cmd.mode==0 || cmd.mode==2)
        && isatty(fileno(stdout))) {
      fprintf(stderr, "%s: encrypted data not written to a terminal. "
              "Use -f to force encryption.\n"
              "Try --help for more information.\n", cmd.name);
      exit(1);
    }
    if ((cmd.mode==1 || cmd.mode==2 || cmd.mode==3
         || cmd.mode==4)
        && isatty(fileno(stdin))) {
      fprintf(stderr, "%s: encrypted data not read from a terminal. "
              "Use -f to force decryption.\n"
              "Try --help for more information.\n", cmd.name);
      exit(1);
    }
  }

  return cmd;
}




int sigint_flag = 0;

void sigint(int dummy) {
  static time_t sigint_time = 0;
  int errno_saved = (*__errno_location ());


  if ((time(((void *)0))-sigint_time) <= 1) {
    fprintf(stderr, "Interrupted.\n");
    exit(6);
  }




  sigint_time = time(((void *)0));
  sigint_flag = 1;
  fprintf(stderr, "Interrupt - will exit after current file. Press CTRL-C twice to exit now.\n");
  (*__errno_location ()) = errno_saved;
}



int main(int ac, char *av[]) {
  int res;
  FILE *f;


  cmd = read_commandline(ac, av);






  if (cmd.keyfile) {
    if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cmd.keyfile) && __builtin_constant_p ("-") && (__s1_len = strlen (cmd.keyfile), __s2_len = strlen ("-"), (!((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (cmd.keyfile), (__const char *) ("-"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (cmd.keyfile) && ((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) && (__s1_len = strlen (cmd.keyfile), __s1_len < 4) ? (__builtin_constant_p ("-") && ((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - ((__const unsigned char *) (__const char *)("-"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("-"); register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("-") && ((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) && (__s2_len = strlen ("-"), __s2_len < 4) ? (__builtin_constant_p (cmd.keyfile) && ((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - ((__const unsigned char *) (__const char *)("-"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (cmd.keyfile); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("-"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; }))) : strcmp (cmd.keyfile, "-")))); })==0) {
      f = stdin;
    } else {
      f = fopen(cmd.keyfile, "r");
      if (!f) {
        fprintf(stderr, "%s: could not read key from %s: ", cmd.name, cmd.keyfile);
        perror("");
        exit(1);
      }
    }

    cmd.keyword = xreadline(f, cmd.name);
    if (cmd.keyword==((void *)0)) {
      exit(0);
    }
    if (cmd.mode==2) {
      cmd.keyword2 = xreadline(f, cmd.name);
      if (cmd.keyword2==((void *)0)) {
        exit(0);
      }
    }
    if (__extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (cmd.keyfile) && __builtin_constant_p ("-") && (__s1_len = strlen (cmd.keyfile), __s2_len = strlen ("-"), (!((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) || __s1_len >= 4) && (!((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (cmd.keyfile), (__const char *) ("-"), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (cmd.keyfile) && ((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) && (__s1_len = strlen (cmd.keyfile), __s1_len < 4) ? (__builtin_constant_p ("-") && ((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - ((__const unsigned char *) (__const char *)("-"))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) ("-"); register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p ("-") && ((size_t)(const void *)(("-") + 1) - (size_t)(const void *)("-") == 1) && (__s2_len = strlen ("-"), __s2_len < 4) ? (__builtin_constant_p (cmd.keyfile) && ((size_t)(const void *)((cmd.keyfile) + 1) - (size_t)(const void *)(cmd.keyfile) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[0] - ((__const unsigned char *) (__const char *)("-"))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (cmd.keyfile))[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (cmd.keyfile); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) ("-"))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) ("-"))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) ("-"))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) ("-"))[3]); } } __result; }))) : strcmp (cmd.keyfile, "-")))); })!=0) {
      fclose(f);
    }
  }


  if (cmd.keyword==((void *)0)) {
    if (!cmd.prompt) {
      switch (cmd.mode) {

      case 0: default:
        cmd.prompt = "Enter encryption key: ";
        break;

      case 1: case 3:
        cmd.prompt = "Enter decryption key: ";
        break;

      case 2:
        cmd.prompt = "Enter old key: ";
        break;

      case 4:
        cmd.prompt = "Enter key: ";
        break;
      }
    }
    cmd.keyword = readkey(cmd.prompt, cmd.name);
    if (cmd.keyword==((void *)0)) {
      exit(0);
    }

    if (cmd.timid && cmd.mode==0 && !cmd.filter) {
      char promptagain[strlen(cmd.prompt)+10];
      char *repeat;
      strcpy(promptagain, cmd.prompt);
      strcat(promptagain, "(repeat) ");
      repeat = readkey(promptagain, cmd.name);
      if (repeat==((void *)0) || __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (repeat) && __builtin_constant_p (cmd.keyword) && (__s1_len = strlen (repeat), __s2_len = strlen (cmd.keyword), (!((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((cmd.keyword) + 1) - (size_t)(const void *)(cmd.keyword) == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (repeat), (__const char *) (cmd.keyword), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (repeat) && ((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) && (__s1_len = strlen (repeat), __s1_len < 4) ? (__builtin_constant_p (cmd.keyword) && ((size_t)(const void *)((cmd.keyword) + 1) - (size_t)(const void *)(cmd.keyword) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - ((__const unsigned char *) (__const char *)(cmd.keyword))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - ((__const unsigned char *) (__const char *) (cmd.keyword))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - ((__const unsigned char *) (__const char *) (cmd.keyword))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - ((__const unsigned char *) (__const char *) (cmd.keyword))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) (cmd.keyword); register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (cmd.keyword) && ((size_t)(const void *)((cmd.keyword) + 1) - (size_t)(const void *)(cmd.keyword) == 1) && (__s2_len = strlen (cmd.keyword), __s2_len < 4) ? (__builtin_constant_p (repeat) && ((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - ((__const unsigned char *) (__const char *)(cmd.keyword))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - ((__const unsigned char *) (__const char *) (cmd.keyword))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - ((__const unsigned char *) (__const char *) (cmd.keyword))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - ((__const unsigned char *) (__const char *) (cmd.keyword))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (repeat); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) (cmd.keyword))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) (cmd.keyword))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) (cmd.keyword))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) (cmd.keyword))[3]); } } __result; }))) : strcmp (repeat, cmd.keyword)))); })!=0) {
        fprintf(stderr, "Sorry, keys did not match.\n");
        exit(7);
      }
    }
  }


  if (cmd.mode==2 && cmd.keyword2==((void *)0)) {
    cmd.keyword2 = readkey("Enter new key: ", cmd.name);
    if (cmd.keyword2==((void *)0)) {
      exit(0);
    }

    if (cmd.timid && !cmd.filter) {
      char promptagain[strlen(cmd.prompt)+10];
      char *repeat;
      strcpy(promptagain, "Enter new key: ");
      strcat(promptagain, "(repeat) ");
      repeat = readkey(promptagain, cmd.name);
      if (repeat==((void *)0) || __extension__ ({ size_t __s1_len, __s2_len; (__builtin_constant_p (repeat) && __builtin_constant_p (cmd.keyword2) && (__s1_len = strlen (repeat), __s2_len = strlen (cmd.keyword2), (!((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) || __s1_len >= 4) && (!((size_t)(const void *)((cmd.keyword2) + 1) - (size_t)(const void *)(cmd.keyword2) == 1) || __s2_len >= 4)) ? memcmp ((__const char *) (repeat), (__const char *) (cmd.keyword2), (__s1_len < __s2_len ? __s1_len : __s2_len) + 1) : (__builtin_constant_p (repeat) && ((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) && (__s1_len = strlen (repeat), __s1_len < 4) ? (__builtin_constant_p (cmd.keyword2) && ((size_t)(const void *)((cmd.keyword2) + 1) - (size_t)(const void *)(cmd.keyword2) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - ((__const unsigned char *) (__const char *)(cmd.keyword2))[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s2 = (__const unsigned char *) (__const char *) (cmd.keyword2); register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - __s2[0]); if (__s1_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - __s2[1]); if (__s1_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - __s2[2]); if (__s1_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - __s2[3]); } } __result; }))) : (__builtin_constant_p (cmd.keyword2) && ((size_t)(const void *)((cmd.keyword2) + 1) - (size_t)(const void *)(cmd.keyword2) == 1) && (__s2_len = strlen (cmd.keyword2), __s2_len < 4) ? (__builtin_constant_p (repeat) && ((size_t)(const void *)((repeat) + 1) - (size_t)(const void *)(repeat) == 1) ? (__extension__ ({ register int __result = (((__const unsigned char *) (__const char *) (repeat))[0] - ((__const unsigned char *) (__const char *)(cmd.keyword2))[0]); if (__s2_len > 0 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[1] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[1]); if (__s2_len > 1 && __result == 0) { __result = (((__const unsigned char *) (__const char *) (repeat))[2] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[2]); if (__s2_len > 2 && __result == 0) __result = (((__const unsigned char *) (__const char *) (repeat))[3] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[3]); } } __result; })) : (__extension__ ({ __const unsigned char *__s1 = (__const unsigned char *) (__const char *) (repeat); register int __result = __s1[0] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[0]; if (__s2_len > 0 && __result == 0) { __result = (__s1[1] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[1]); if (__s2_len > 1 && __result == 0) { __result = (__s1[2] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[2]); if (__s2_len > 2 && __result == 0) __result = (__s1[3] - ((__const unsigned char *) (__const char *) (cmd.keyword2))[3]); } } __result; }))) : strcmp (repeat, cmd.keyword2)))); })!=0) {
        fprintf(stderr, "Sorry, keys did not match.\n");
        exit(7);
      }
    }
  }
# 479 "../../src/src/main.c"
  if (cmd.filter) {
    switch (cmd.mode) {

    case 0: default:
      res = ccencrypt_streams(stdin, stdout, cmd.keyword);
      break;

    case 1: case 3:
      res = ccdecrypt_streams(stdin, stdout, cmd.keyword);
      break;

    case 2:
      res = cckeychange_streams(stdin, stdout, cmd.keyword, cmd.keyword2);
      break;

    case 4:
      res = unixcrypt_streams(stdin, stdout, cmd.keyword);
      break;
    }

    if (res) {
      fprintf(stderr, "%s: %s\n", cmd.name, ccrypt_error(res));
      if (res<0) return 3;
      else if (res==2) return 4;
      else return 5;
    }
    fflush(stdout);
    return 0;
  }

  if (cmd.mode!=3 && cmd.mode!=4) {

    signal(2, sigint);
  }


  reset_inodes();
  traverse_files(cmd.infiles, cmd.count);
  return 0;
}

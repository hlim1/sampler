AC_INIT(sampler,0.0,liblit@cs.berkeley.edu)
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE


########################################################################
#
#  Sampler internal configuration
#


AC_MSG_CHECKING(for precomputed countdown size)
PRECOMPUTE_COUNT=1021
AC_SUBST(PRECOMPUTE_COUNT, $PRECOMPUTE_COUNT)
AC_MSG_RESULT($PRECOMPUTE_COUNT)

AC_MSG_CHECKING(for absolute build directory)
AC_SUBST(ABSOLUTE_BUILDDIR, $PWD)
AC_MSG_RESULT($PWD)


########################################################################
#
#  OCaml configuration
#


AC_MSG_CHECKING(for CIL build tree)
AC_ARG_WITH(cil, [  --with-cil=DIR          CIL build tree], , with_cil=../cil)
if ! test -d "$with_cil"; then
  AC_MSG_ERROR(cannot find CIL build tree; please use --with-cil=DIR)
fi
CIL_HOME=`cd "$with_cil"; pwd`
AC_SUBST(CIL_HOME)
AC_MSG_RESULT($CIL_HOME)


AC_MSG_CHECKING(for profiling)
AC_ARG_ENABLE(profiling, [  --enable-profiling      Compile OCaml for gprof profiling (implies --enable-native)])
if test "$enable_profiling" = yes; then
  enable_native=yes
  AC_SUBST(ENABLE_PROFILING, 1)
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi


AC_MSG_CHECKING(for native compilation)
AC_ARG_ENABLE(native, [  --enable-native         Compile OCaml to native code (default: compile to bytecode)])
AM_CONDITIONAL(ENABLE_NATIVE, test "$enable_native" = yes)
if test "$enable_native" = yes; then
  AC_SUBST(ENABLE_NATIVE, 1)
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi


########################################################################
#
#  C configuration
#

: ${CFLAGS:=-O9 -W -Wall -Werror}
: ${CXXFLAGS:=-O9 -W -Wall -Werror}

AC_PROG_CC
AC_PROG_CXX
AM_PROG_LEX
AC_PROG_RANLIB

AC_MSG_CHECKING(format string type modifer j)
AC_COMPILE_IFELSE(
  AC_LANG_PROGRAM(
    [#include <stdint.h>
     #include <stdio.h>],
    [printf("%jd\n", (intmax_t) 0);]),
  AC_DEFINE(HAVE_FORMAT_STRING_TYPE_MODIFIER_j, 1, [Define if C compiler supports format string type modifier "j"])
  AC_MSG_RESULT(yes),
  AC_MSG_RESULT(no))

AC_MSG_CHECKING(thread-local storage specifier)
AC_COMPILE_IFELSE(
  AC_LANG_PROGRAM([__thread int x;], []),
  have_thread_storage=yes
  AC_MSG_RESULT(yes),
  AC_MSG_RESULT(no))
AM_CONDITIONAL(HAVE_THREAD_STORAGE, test "$have_thread_storage" = yes)

AC_MSG_CHECKING(log without -lm)
old_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS -ffast-math"
AC_LINK_IFELSE(
  AC_LANG_PROGRAM([#include <math.h>], [log(1.)]),
  AC_MSG_RESULT(yes),
  AC_MSG_RESULT(no)
  AC_SUBST(LIBM, -lm))
CFLAGS=$old_CFLAGS


########################################################################
#
#  Output
#

AM_CONFIG_HEADER(config.h)

AC_CONFIG_TESTDIR(instrumentor/branches/tests)
AC_CONFIG_TESTDIR(instrumentor/decure/tests)
AC_CONFIG_TESTDIR(instrumentor/nothing/tests)
AC_CONFIG_TESTDIR(instrumentor/returns/tests)
AC_CONFIG_TESTDIR(instrumentor/scalar-pairs/tests)

AC_CONFIG_FILES([
Makefile
benchmarks/Makefile
benchmarks/ccured/Makefile
benchmarks/ccured/bh/Makefile
benchmarks/ccured/bisort/Makefile
benchmarks/ccured/compress/Makefile
benchmarks/ccured/em3d/Makefile
benchmarks/ccured/go/Makefile
benchmarks/ccured/health/Makefile
benchmarks/ccured/ijpeg/Makefile
benchmarks/ccured/li/Makefile
benchmarks/ccured/mst/Makefile
benchmarks/ccured/perimeter/Makefile
benchmarks/ccured/power/Makefile
benchmarks/ccured/treeadd/Makefile
benchmarks/ccured/tsp/Makefile
doc/Makefile
doc/config.xml
fuzz/Makefile
instrumentor/Makefile
instrumentor/config.mk
instrumentor/branches/Makefile
instrumentor/branches/libbranches/Makefile
instrumentor/branches/tests/Makefile
instrumentor/daikon/Makefile
instrumentor/daikon/libdaikon/Makefile
instrumentor/decure/Makefile
instrumentor/decure/tests/Makefile
instrumentor/driver/main-subst
instrumentor/driver/Makefile
instrumentor/nothing/Makefile
instrumentor/nothing/tests/Makefile
instrumentor/returns/Makefile
instrumentor/returns/libreturns/Makefile
instrumentor/returns/tests/Makefile
instrumentor/scalar-pairs/Makefile
instrumentor/scalar-pairs/libscalar-pairs/Makefile
instrumentor/scalar-pairs/tests/Makefile
launcher/Makefile
launcher/python/Makefile
launcher/applications/Makefile
launcher/applications/gnumeric/Makefile
libcountdown/Makefile
libcountdown/cyclic-size.h
libreport/Makefile
libtuples/Makefile
mining/Makefile
mining/libodbc++/Makefile
mining/populate/Makefile
])

AC_OUTPUT

AC_INIT(sampler,0.0)
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE(sampler,0.0)

AC_MSG_CHECKING(for CIL build tree)
AC_ARG_WITH(cil, [  --with-cil=DIR          CIL build tree], , with_cil=../cil)
if ! test -d "$with_cil"; then
  AC_MSG_ERROR(cannot find CIL build tree; please use --with-cil=DIR)
fi
CIL_HOME=`cd "$with_cil"; pwd`
AC_SUBST(CIL_HOME)
AC_MSG_RESULT($CIL_HOME)

: ${CFLAGS:=-g -W -Wall -Werror}
: ${CXXFLAGS:=-g -W -Wall -Werror}

AC_PROG_CC
AC_PROG_CXX
AM_PROG_LEX
AC_PROG_RANLIB

AC_C_INLINE
AC_EGREP_CPP(inline, inline, 
  AC_DEFINE(HAVE_INLINE, 1,
	   [Define to tell GSL that we can handle inline functions.])
)


########################################################################


AM_CONFIG_HEADER(config.h)

AC_CONFIG_TESTDIR(instrumentor/branches/tests)
AC_CONFIG_TESTDIR(instrumentor/decure/tests)
AC_CONFIG_TESTDIR(instrumentor/nothing/tests)
AC_CONFIG_TESTDIR(instrumentor/returns/tests)
AC_CONFIG_TESTDIR(instrumentor/scalar-pairs/tests)

AC_CONFIG_FILES([
Makefile
benchmarks/ccured/config.mk
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
launcher/applications/Makefile
launcher/applications/gnumeric/Makefile
libcountdown/Makefile
liblog/Makefile
libreport/Makefile
mining/Makefile
mining/libodbc++/Makefile
mining/populate/Makefile
])

AC_OUTPUT

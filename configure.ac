AC_INIT(sampler,0.1,liblit@cs.berkeley.edu)
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE


########################################################################
#
#  Sampler internal configuration
#


AC_PATH_PROGS(XSL_HTML, docbook.xsl, , /usr/share/sgml/docbook/xsl-stylesheets/xhtml:/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/xhtml:/usr/share/apps/ksgmltools2/docbook/xsl/html)
if test -z "$XSL_HTML"; then
  AC_MSG_WARN(cannot find DocBook XML-to-XHTML style sheet)
  AC_MSG_WARN(HTML documentation will not be built)
  AC_MSG_WARN(consider setting \$XSL_HTML)
fi
AM_CONDITIONAL(HAVE_XSL_HTML, test -n "$XSL_HTML")

AC_CHECK_PROG(XMLLINT, xmllint, xmllint, \$(top_srcdir)/tools/skip-test)
if test "$XMLLINT" != xmllint; then
  AC_MSG_WARN(cannot find xmllint in \$PATH)
  AC_MSG_WARN(XML validation tests will be skipped)
fi

AC_MSG_CHECKING(for precomputed countdown size)
PRECOMPUTE_COUNT=1021
AC_SUBST(PRECOMPUTE_COUNT, $PRECOMPUTE_COUNT)
AC_MSG_RESULT($PRECOMPUTE_COUNT)

AC_MSG_CHECKING(for absolute build directory)
AC_SUBST(ABSOLUTE_BUILDDIR, $PWD)
AC_MSG_RESULT($PWD)

AC_MSG_CHECKING(for build host name)
AC_SUBST(BUILD_HOST, `hostname`)
AC_MSG_RESULT($BUILD_HOST)


AC_SUBST(package_libdir,  '${libdir}/${PACKAGE}')
AC_SUBST(instrumentordir, '${package_libdir}/instrumentor')
AC_SUBST(schemedir, '${instrumentordir}/${scheme}')
AC_SUBST(toolsdir, '${package_libdir}/tools')
AC_SUBST(package_datadir, '${datadir}/${PACKAGE}')
AC_SUBST(launcherdir, '${package_datadir}/launcher')

find_driver_fragment=tools/find-driver.pl
AC_SUBST_FILE(find_driver_fragment)


########################################################################
#
#  CIL configuration
#


link=$srcdir/instrumentor/cil
if test -h $link; then rm $link; fi

AC_MSG_CHECKING(for CIL build tree)
if test -d $link; then
  with_cil=instrumentor/cil
else
  AC_ARG_WITH(cil, [  --with-cil=DIR          CIL build tree], , with_cil=../cil)
  if ! test -d $with_cil; then
    AC_MSG_RESULT($with_cil (not a directory))
    AC_MSG_ERROR(cannot find CIL build tree; please use --with-cil=DIR)
  fi
  with_cil="`cd $with_cil; pwd`"
  ln -sf $with_cil $link
fi

AC_MSG_RESULT($with_cil)
AC_CONFIG_SUBDIRS(instrumentor/cil)


AC_MSG_CHECKING(for CIL version)
cil_version=`$srcdir/tools/find-cil-version <$with_cil/configure.in`
AC_SUBST(cil_version)
AC_MSG_RESULT($cil_version)


########################################################################
#
#  OCaml configuration
#


AC_CHECK_PROGS(OCAMLOPT, ocamlopt.opt ocamlopt)
if test -z "$OCAMLOPT"; then
  AC_MSG_ERROR(cannot find OCaml native compiler; please set \$OCAMLOPT)
fi

AC_CHECK_PROGS(OCAMLC, ocamlc.opt ocamlc)
if test -z "$OCAMLC"; then
  AC_MSG_ERROR(cannot find OCaml bytecode compiler; please set \$OCAMLC)
fi


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


AC_MSG_CHECKING(for thread-local storage qualifier)
AC_RUN_IFELSE(
  AC_LANG_PROGRAM([__thread int global;], []),
  have_thread_storage=yes,
  have_thread_storage=no)
AC_MSG_RESULT($have_thread_storage)

if test "$have_thread_storage" != no; then
  AC_MSG_CHECKING(whether thread-local storage actually works)
  AC_RUN_IFELSE(
    AC_LANG_PROGRAM([__thread int global;], [global = 0; return 0;]),
    have_thread_storage=yes,
    have_thread_storage=no,
    have_thread_storage='optimistically assuming yes')
  AC_MSG_RESULT($have_thread_storage)
fi

if test "$have_thread_storage" = no; then
  AC_MSG_WARN(cannot instrument multithreaded applications)
else
  HAVE_THREAD_STORAGE=1
fi

AC_SUBST(HAVE_THREAD_STORAGE)
AM_CONDITIONAL(HAVE_THREAD_STORAGE, test "$have_thread_storage" != no)


AC_MSG_CHECKING(for log without -lm)
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
config.m4
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
instrumentor/driver/sampler-cc
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
libthreads/Makefile
libtuples/Makefile
package.m4
sampler.spec
tools/Makefile
tools/debuild
tools/rpmbuild
])

AC_OUTPUT

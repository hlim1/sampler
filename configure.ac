AC_INIT(sampler,0.4,liblit@cs.berkeley.edu)
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE


########################################################################
#
#  XML configuration
#


AC_CHECK_PROG(sk_config, scrollkeeper-config, scrollkeeper-config)
if test "$sk_config" != scrollkeeper-config; then
  AC_MSG_ERROR(cannot find scrollkeeper-config in $\PATH)
fi


AC_CHECK_PROG(XMLLINT, xmllint, xmllint, \$(top_srcdir)/tools/skip-test)
if test "$XMLLINT" != xmllint; then
  AC_MSG_WARN(cannot find xmllint in \$PATH)
  AC_MSG_WARN(XML validation tests will be skipped)
fi


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

AC_MSG_CHECKING(for build host name)
AC_SUBST(BUILD_HOST, `hostname`)
AC_MSG_RESULT($BUILD_HOST)


AC_SUBST(package_libdir,  '${libdir}/${PACKAGE}')
AC_SUBST(instrumentordir, '${package_libdir}/instrumentor')
AC_SUBST(liblibdir, '${package_libdir}/lib')
AC_SUBST(cillibdir, '${instrumentordir}/cil/lib')
AC_SUBST(driverdir, '${instrumentordir}/driver')
AC_SUBST(schemedir, '${instrumentordir}/${scheme}')
AC_SUBST(toolsdir, '${package_libdir}/tools')
AC_SUBST(aclocaldir, '${datadir}/aclocal')
AC_SUBST(package_datadir, '${datadir}/${PACKAGE}')
AC_SUBST(launcherdir, '${package_datadir}/launcher')
AC_SUBST(fragmentsdir, '${package_datadir}/fragments')
AC_SUBST(fragments_samplerdir, '${fragmentsdir}/sampler')
AC_SUBST(templatesdir, '${package_datadir}/templates')
AC_SUBST(wwwdir, '${localstatedir}/www')

find_driver_fragment=tools/find-driver.pl
AC_SUBST_FILE(find_driver_fragment)


########################################################################
#
#  CIL configuration
#


AC_MSG_CHECKING(for CIL in sibling build tree)
if test -d ../cil; then
  cil_absolute=`cd ../cil; pwd`
  cil_libdir=$cil_absolute/obj/x86_LINUX
  cil_datadir=$cil_absolute/lib
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi

if test -z "$cil_libdir"; then
  for cil_prefix in /usr/local /usr; do
    AC_MSG_CHECKING(for CIL in $cil_prefix)
    if test -d $cil_prefix/lib/cil -a -d $cil_prefix/share/cil; then
      cil_libdir=$cil_prefix/lib/cil
      cil_datadir=$cil_prefix/share/cil
      AC_MSG_RESULT(yes)
      break
    else
      AC_MSG_RESULT(no)
    fi
  done
fi

if test -z "$cil_libdir"; then
  AC_MSG_ERROR(cannot find CIL)
fi

AC_SUBST(cil_libdir)
AC_SUBST(cil_datadir)


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
AC_ARG_ENABLE(native, [  --disable-native        Compile OCaml to bytecode (default: compile to native code)], , enable_native=yes)
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

AC_PROG_CC
AC_PROG_RANLIB
AC_PROG_LN_S

PKG_CHECK_MODULES(LAUNCHER_TRAY, gtk+-2.0 pygtk-2.0)
AC_SUBST(LAUNCHER_TRAY_LIBS)
AC_SUBST(LAUNCHER_TRAY_CFLAGS)

PKG_CHECK_MODULES(EGG_TRAY, gtk+-2.0 libgnomeui-2.0)
AC_SUBST(EGG_TRAY_LIBS)
AC_SUBST(EGG_TRAY_CFLAGS)

PKG_CHECK_MODULES(ORBIT, ORBit-2.0)
AC_SUBST(ORBIT_LIBS)
AC_SUBST(ORBIT_CFLAGS)

PKG_CHECK_MODULES(BONOBO, libbonobo-2.0)
AC_SUBST(BONOBO_LIBS)
AC_SUBST(BONOBO_CFLAGS)

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
AC_COMPILE_IFELSE(
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
debian/Makefile
doc/Makefile
doc/config.xml
doc/sampler-guide/Makefile
doc/sampler-guide/C/Makefile
fuzz/Makefile
instrumentor/Makefile
instrumentor/config.mk
instrumentor/branches/Makefile
instrumentor/branches/tests/Makefile
instrumentor/daikon/Makefile
instrumentor/decure/Makefile
instrumentor/decure/tests/Makefile
instrumentor/driver/Makefile
instrumentor/nothing/Makefile
instrumentor/nothing/tests/Makefile
instrumentor/returns/Makefile
instrumentor/returns/tests/Makefile
instrumentor/scalar-pairs/Makefile
instrumentor/scalar-pairs/tests/Makefile
launcher/Makefile
launcher/python/Makefile
launcher/tray/Makefile
launcher/tray/corba/Makefile
launcher/tray/libegg/Makefile
launcher/tray/libegg/tray/Makefile
lib/Makefile
lib/cyclic-size.h
package.m4
sampler.spec
tools/Makefile
tools/find-driver.pl
www/Makefile
www/cgi-bin/Makefile
])

AC_CONFIG_FILES([instrumentor/driver/main], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/driver/sampler-cc], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/debuild], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/rpmbuild], [chmod +x $ac_file])

AC_OUTPUT

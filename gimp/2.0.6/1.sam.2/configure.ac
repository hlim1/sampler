AC_INIT([sampler],[0.14],[liblit@cs.berkeley.edu])
AC_CONFIG_AUX_DIR(config-aux)
AM_INIT_AUTOMAKE


########################################################################
#
#  Linux distribution
#

for vendor in fedora redhat; do
  AC_MSG_CHECKING(for $vendor)
  if version="`rpm -q --qf '%{version}' $vendor-release`"; then
    DISTRO="$vendor-$version"
    AC_MSG_RESULT($version)
    AC_MSG_CHECKING(RPM build architecture)
    RPM_ARCH="`rpm -q --qf '%{arch}' $vendor-release`"
    AC_MSG_RESULT($RPM_ARCH)
    break
  else
    AC_MSG_RESULT(no)
  fi
done

: ${DISTRO:=unknown}
: ${RPM_ARCH:=unknown}

AC_SUBST(DISTRO)
AC_SUBST(RPM_ARCH)


########################################################################
#
#  Basic C configuration
#

AC_PROG_CC
AC_PROG_CXX
AC_PROG_RANLIB
AM_PROG_LEX
AC_PROG_LN_S


########################################################################
#
#  GNOME and GTK+ configuration
#


AC_ARG_WITH(gnome, AC_HELP_STRING([--without-gnome], [do not build GNOME-based GUI tools]), , with_gnome=yes)

if test "$with_gnome" = yes; then

  PKG_CHECK_MODULES(TRAY_ICON, gtk+-2.0 pygtk-2.0)
  AC_SUBST(TRAY_ICON_CFLAGS)
  AC_SUBST(TRAY_ICON_LIBS)

  PKG_CHECK_MODULES(MONITOR, gtk+-2.0 pygtk-2.0 libbonobo-2.0)
  AC_SUBST(MONITOR_CFLAGS)
  AC_SUBST(MONITOR_LIBS)

  PKG_CHECK_MODULES(EGG_TRAY, gtk+-2.0)
  AC_SUBST(EGG_TRAY_CFLAGS)
  AC_SUBST(EGG_TRAY_LIBS)

  AM_PATH_GLIB_2_0(, , , gobject)

  AM_PATH_PYTHON
  AC_SUBST(PYTHON_CFLAGS, '-I/usr/include/python${PYTHON_VERSION}')
  AC_SUBST(PYTHON_LIBS, '-L/usr/lib/python${PYTHON_VERSION}/config -lpython${PYTHON_VERSION}')
fi

AM_GCONF_SOURCE_2

AC_MSG_CHECKING(for GNOME support)
AM_CONDITIONAL(WITH_GNOME, test "$with_gnome" = yes)
AC_MSG_RESULT($with_gnome)


########################################################################
#
#  XML configuration
#


AC_CHECK_PROG(sk_config, scrollkeeper-config, scrollkeeper-config)
if test "$sk_config" != scrollkeeper-config; then
  AC_MSG_ERROR(cannot find scrollkeeper-config in $\PATH)
fi


AC_CHECK_PROG(XMLLINT, xmllint, xmllint, \${top_srcdir}/tools/skip-test)
if test "$XMLLINT" != xmllint; then
  AC_MSG_WARN(cannot find xmllint in \$PATH)
  AC_MSG_WARN(XML validation tests will be skipped)
fi


########################################################################
#
#  Sampler internal configuration
#


AC_SUBST(schemadir, '${GCONF_SCHEMA_FILE_DIR}')
AC_SUBST(serversdir, '${libdir}/bonobo/servers')
AC_SUBST(package_includedir, '${includedir}/sampler')

AC_SUBST(package_libdir, '${libdir}/${PACKAGE}')
AC_SUBST(schemedir, '${instrumentordir}/${scheme}')
AC_SUBST(instrumentordir, '${package_libdir}/instrumentor')
AC_SUBST(driverdir, '${instrumentordir}/driver')
AC_SUBST(toolsdir, '${package_libdir}/tools')
AC_SUBST(traylibdir, '${package_libdir}/tray')

AC_SUBST(package_datadir, '${datadir}/${PACKAGE}')
AC_SUBST(commondir, '${package_datadir}/common')
AC_SUBST(first_timedir, '${package_datadir}/first-time')
AC_SUBST(launcherdir, '${package_datadir}/launcher')
AC_SUBST(pixmapsdir, '${package_datadir}/pixmaps')
AC_SUBST(preferencesdir, '${package_datadir}/preferences')
AC_SUBST(traydir, '${package_datadir}/tray')
AC_SUBST(wrapperdir, '${package_datadir}/wrapper')

AC_SUBST(wwwdir, '${localstatedir}/www')

find_driver_fragment=tools/find-driver.pl
AC_SUBST_FILE(find_driver_fragment)


########################################################################
#
#  CIL configuration
#


AC_ARG_WITH(cil-sibling, AC_HELP_STRING([--without-cil-sibling], [do not look for CIL in sibling build tree]),
,
AC_MSG_CHECKING(for CIL in sibling build tree)
if test -d ../cil; then
  with_cil_sibling=yes
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
)

if test "$with_cil_sibling" = yes; then
  cil_absolute=`cd ../cil; pwd`
  cil_libdir=$cil_absolute/obj/x86_LINUX

elif test -z "$cil_libdir"; then
  for cil_prefix in /usr/local /usr; do
    AC_MSG_CHECKING(for CIL in $cil_prefix)
    if test -d $cil_prefix/lib/cil; then
      cil_libdir=$cil_prefix/lib/cil
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


AC_MSG_CHECKING(whether $OCAMLC supports -dtypes)
if $OCAMLC -help 2>&1 | grep -q dtypes; then
  DTYPES=-dtypes
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST(DTYPES)


AC_MSG_CHECKING(for profiling)
AC_ARG_ENABLE(profiling, AC_HELP_STRING([--enable-profiling], [Compile OCaml for gprof profiling (implies --enable-native)]), , enable_profiling=no)
AM_CONDITIONAL(ENABLE_PROFILING, test "$enable_profiling" = yes)
AC_MSG_RESULT($enable_profiling)
if test "$enable_profiling" = yes; then
  enable_native=yes
fi


AC_MSG_CHECKING(for native compilation)
AC_ARG_ENABLE(native, AC_HELP_STRING([--disable-native], [Compile OCaml to bytecode (default: compile to native code)]), , enable_native=yes)
AM_CONDITIONAL(ENABLE_NATIVE, test "$enable_native" = yes)
AC_MSG_RESULT($enable_native)


########################################################################
#
#  Advanced C configuration
#


gcc=$CC
AC_MAKE_ABSOLUTE(gcc)

AC_MSG_CHECKING(for cpp0)
AC_SUBST(cpp0, `$CC -print-prog-name=cpp0`)
AC_MSG_RESULT($cpp0)
AC_MAKE_ABSOLUTE(cpp0, [])

AC_MSG_CHECKING(for cc1)
AC_SUBST(cc1, `$CC -print-prog-name=cc1`)
AC_MSG_RESULT($cc1)
AC_MAKE_ABSOLUTE(cc1)

AC_MSG_CHECKING(for as)
AC_SUBST(as, `$CC -print-prog-name=as`)
AC_MSG_RESULT($as)
AC_MAKE_ABSOLUTE(as)


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


AM_PATH_GSL


########################################################################
#
#  Output
#

AM_CONFIG_HEADER(config.h)

AC_CONFIG_TESTDIR(instrumentor/balance)
AC_CONFIG_TESTDIR(instrumentor/bounds)
AC_CONFIG_TESTDIR(instrumentor/branches)
AC_CONFIG_TESTDIR(instrumentor/function-entries)
AC_CONFIG_TESTDIR(instrumentor/g-object-unref)
AC_CONFIG_TESTDIR(instrumentor/nothing)
AC_CONFIG_TESTDIR(instrumentor/returns)
AC_CONFIG_TESTDIR(instrumentor/scalar-pairs)
AC_CONFIG_TESTDIR(instrumentor/timestamps)

AC_CONFIG_FILES([
Makefile
config.m4
debian/Makefile
doc/Makefile
doc/config.xml
doc/sampler-guide/Makefile
doc/sampler-guide/C/Makefile
fuzz/Makefile
instrumentor/Makefile
instrumentor/balance/Makefile
instrumentor/bounds/Makefile
instrumentor/branches/Makefile
instrumentor/driver/Makefile
instrumentor/function-entries/Makefile
instrumentor/g-object-unref/Makefile
instrumentor/g-object-unref/atlocal
instrumentor/nothing/Makefile
instrumentor/returns/Makefile
instrumentor/scalar-pairs/Makefile
instrumentor/timestamps/Makefile
instrumentor/version.ml
launcher/Makefile
launcher/common/Makefile
launcher/first-time/Makefile
launcher/monitor/Makefile
launcher/pixmaps/Makefile
launcher/preferences/Makefile
launcher/tray/Makefile
launcher/trayicon/Makefile
launcher/trayicon/libegg/Makefile
launcher/trayicon/libegg/tray/Makefile
launcher/wrapper/Makefile
lib/Makefile
mining/analysis/Makefile
mining/dumps/Makefile
mining/Makefile
mining/populate/Makefile
mining/queries/Makefile
ocaml/Makefile
package.m4
sampler.spec
tools/Makefile
tools/cfg/Makefile
tools/cfg/graphlib/Makefile
tools/find-driver.pl
www/Makefile
www/cgi-bin/Makefile
])

AC_CONFIG_FILES([launcher/test-by-extension], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/driver/sampler-cc], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/driver/sampler-cc-here], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/driver/as], [chmod +x $ac_file])
AC_CONFIG_FILES([instrumentor/driver/cc1], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/debuild], [chmod +x $ac_file])
AC_CONFIG_FILES([tools/rpmbuild], [chmod +x $ac_file])

AC_OUTPUT

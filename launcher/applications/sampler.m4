dnl -*- autoconf -*-


dnl --------------------------------------------------------------------
dnl
dnl SAMPLER_ARG_ENABLE
dnl

AC_DEFUN([SAMPLER_ARG_ENABLE],
[
AC_MSG_CHECKING([for sampled instrumentation])
AC_ARG_ENABLE([sampler], [  --enable-sampler=SCHEME  add sampled instrumentation], [], enable_sampler=no)
AC_MSG_RESULT([$enable_sampler])

case "$enable_sampler" in
  (yes) AC_MSG_ERROR([must select a specific sampling scheme]) ;;
  (no) ;;
  (*) SAMPLER_SCHEME=$enable_sampler
esac

AC_SUBST([SAMPLER_SCHEME])
AM_CONDITIONAL([ENABLE_SAMPLER], [test -n "$SAMPLER_SCHEME"])
])


dnl --------------------------------------------------------------------
dnl
dnl SAMPLER_PROG_CC
dnl

AC_DEFUN([SAMPLER_PROG_CC],
[
AC_REQUIRE([SAMPLER_ARG_ENABLE])

if test -n "$SAMPLER_SCHEME"; then
  AC_ARG_VAR([SAMPLER_CC])
  AC_CHECK_PROGS([SAMPLER_CC], [sampler-cc])
  if test -z "$SAMPLER_CC"; then
    AC_MSG_ERROR([instrumenting C compiler not found in \$PATH])
  fi
  new_CC="${SAMPLER_CC} ${SAMPLER_SCHEME}"
  if test -n "$CC" -a "$CC" != "$new_CC"; then
    AC_MSG_WARN([sampler: overriding \$CC from environment])
  fi
  CC=$new_CC
fi
])


dnl --------------------------------------------------------------------
dnl
dnl SAMPLER_LAUNCHER([EXECUTABLE], [ICON])
dnl

AC_DEFUN([SAMPLER_LAUNCHER],
[
AC_REQUIRE([SAMPLER_ARG_ENABLE])
AC_REQUIRE([AC_PROG_LN_S])
AC_REQUIRE([AM_GCONF_SOURCE_2])

if test -n "$SAMPLER_SCHEME"; then
  AC_MSG_CHECKING([for wrapped executable])
  AC_SUBST([SAMPLER_EXECUTABLE], ['m4_if([$1], [], [${bindir}/${PACKAGE}], [$1])'])
  AC_MSG_RESULT([$SAMPLER_EXECUTABLE])

  AC_MSG_CHECKING([for wrapper icon])
  AC_SUBST([SAMPLER_ICON], ['m4_if([$2], [], [${datadir}/pixmaps/${PACKAGE}.png], [$2])'])
  AC_MSG_RESULT([$SAMPLER_ICON])

  AC_SUBST([launcherdir], ['${libdir}/sampler/applications/${PACKAGE}'])
  AC_CONFIG_FILES([sampler/Makefile])

  sampler_spec_tags=sampler/spec/tags
  sampler_spec_description=sampler/spec/description
  sampler_spec_files=sampler/spec/files
  sampler_spec_postinstall=sampler/spec/postinstall
else
  sampler_spec_tags=/dev/null
  sampler_spec_description=/dev/null
  sampler_spec_files=/dev/null
  sampler_spec_postinstall=/dev/null
fi

AC_SUBST_FILE(sampler_spec_tags)
AC_SUBST_FILE(sampler_spec_description)
AC_SUBST_FILE(sampler_spec_files)
AC_SUBST_FILE(sampler_spec_postinstall)
])

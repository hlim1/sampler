# AC_MAKE_ABSOLUTE(VAR, [PATH])
# ------------------------------
AC_DEFUN([AC_MAKE_ABSOLUTE],
[case $$1 in
  (/*) ;;
  (*) AC_PATH_PROG($1, $$1, $2) ;;
esac])

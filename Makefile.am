AUTOMAKE_OPTIONS = foreign

SUBDIRS =					\
	fuzz					\
	instrumentor				\
	launcher				\
	libcountdown				\
	liblog					\
	libreport

EXTRA_DIST = package.m4

all-local: package.m4

$(srcdir)/package.m4: configure.ac
	{									\
	  echo '# Signature of the current package.';				\
	  echo 'm4_define([AT_PACKAGE_NAME],      [@PACKAGE_NAME@])';		\
	  echo 'm4_define([AT_PACKAGE_TARNAME],   [@PACKAGE_TARNAME@])';	\
	  echo 'm4_define([AT_PACKAGE_VERSION],   [@PACKAGE_VERSION@])';	\
	  echo 'm4_define([AT_PACKAGE_STRING],    [@PACKAGE_STRING@])';		\
	  echo 'm4_define([AT_PACKAGE_BUGREPORT], [@PACKAGE_BUGREPORT@])';	\
	} >$@

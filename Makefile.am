AUTOMAKE_OPTIONS = foreign

SUBDIRS =					\
	doc					\
	fuzz					\
	instrumentor				\
	launcher				\
	libcountdown				\
	libreport

DIST_SUBDIRS = $(SUBDIRS) mining

EXTRA_DIST =					\
	package.m4				\
	resolver

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

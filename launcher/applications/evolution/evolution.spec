# RPM specfile for evolution module
# Generated Tue Jul  8 20:57:03 2003 GMT by Ximian build system
# $Id: evolution.spec,v 1.2 2003/08/12 07:23:26 liblit Exp $
# from $Id: evolution.spec,v 1.2 2003/08/12 07:23:26 liblit Exp $

%define nam	evolution
%define ver	1.4.3
%define licensedir	%{_datadir}/licenses/%{nam}-%{ver}
%define ximrev	1

Name:     	evolution
Version: 	1.4.3
Release:	0.ximian.6.1.sam.1
Vendor:		Ximian, Inc.
Distribution:	Ximian GNOME for Red Hat Linux 9 / i386
Copyright:	GPL
BuildRoot:	/var/tmp/%{nam}-%{ver}-root
Docdir:         /usr/share/doc

URL:		http://www.gnome.org/
Source0:	evolution-1.4.3.tar.gz
Patch0:		forward_messages.patch
BuildRequires:	bison
BuildRequires:	evo-db3
BuildRequires:	openldap-devel
BuildRequires:	gtkhtml3.0-devel >= 3.0.4
BuildRequires:	libgal2.0-devel >= 1.99.6
BuildRequires:	libbonoboui-devel
BuildRequires:	bonobo-activation-devel
BuildRequires:	gnome-vfs2-devel
BuildRequires:	libglade2-devel
BuildRequires:	GConf2-devel
BuildRequires:	ORBit2-devel
BuildRequires:	libgnomeprintui22-devel
BuildRequires:	libxml2-devel
BuildRequires:	intltool >= 0.20
BuildRequires:	gtk2-devel
BuildRequires:	mozilla-nspr
BuildRequires:	mozilla-nspr-devel
BuildRequires:	mozilla-nss
BuildRequires:	mozilla-nss-devel
BuildRequires:	gnome-pilot-devel >= 2.0.5
BuildRequires:	krb5-devel
BuildRequires:	flex
BuildRequires:	libsoup-devel >= 1.99.22
Summary:	GNOME's next-generation groupware suite
Group:		Applications/Productivity
Requires:	libgtkhtml3.0_2 >= 3.0.7
Requires:	gtkhtml3.0 >= 3.0.7
Requires:	libgal2.0_3 >= 1.99.8
Requires:	libsoup >= 1.99.23
Requires:	libgnomecanvas >= 2.2.0.2
Provides:	ximian-evolution = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}
Obsoletes:	evolution1.3
Prereq:	GConf2
Prereq:	scrollkeeper
%sampler_tags

%description
Evolution is the GNOME mailer, calendar, contact manager and
communications tool.  The tools which make up Evolution will
be tightly integrated with one another and act as a seamless
personal information-management tool.

%sampler_description

%files
%defattr(-, root, root)
%doc AUTHORS COPYING ChangeLog INSTALL NEWS README
/usr/share/applications/*
/usr/share/mime-info/*
/usr/share/idl/*
/usr/share/evolution/1.4
/usr/share/pixmaps/*
/usr/*/locale/*/LC_MESSAGES/*.mo
/usr/lib/evolution/1.4/*cal*.so.*
/usr/lib/evolution/1.4/libe*.so.*
/usr/lib/evolution/1.4/libwombat.so.*
/usr/lib/evolution/1.4/libversit.so.*
/usr/lib/bonobo/servers/*.server
/usr/lib/evolution/1.4/evolution-calendar-importers/*.so
/usr/lib/evolution/1.4/evolution-mail-importers/*.so
/usr/lib/evolution/1.4/components/*.so
/usr/libexec/evolution/1.4/evolution-wombat
/usr/libexec/evolution/1.4/evolution-addressbook-import
/usr/libexec/evolution/1.4/killev
/usr/libexec/evolution/1.4/csv2vcard
/usr/libexec/evolution/1.4/evolution-addressbook-clean
/usr/libexec/evolution/1.4/evolution-alarm-notify
/usr/libexec/evolution/1.4/load-*-addressbook
/usr/libexec/evolution/1.4/*importer
/usr/bin/evolution
/usr/bin/evolution-1.4
/usr/bin/evolution-addressbook-export
/etc/gconf/schemas/*.schemas
/usr/share/omf/*
/usr/share/gnome/help/*
%dir /usr/share/pixmaps
%dir /usr/share/evolution
%dir /usr/lib/evolution
%dir /usr/lib/evolution/1.4
%dir /usr/lib/evolution/1.4/components
%dir /usr/lib/evolution/1.4/evolution-calendar-importers
%dir /usr/lib/evolution/1.4/evolution-mail-importers
%dir /usr/libexec/evolution
%dir /usr/libexec/evolution/1.4
/usr/lib/evolution/1.4/camel-providers/*.so
/usr/lib/evolution/1.4/camel-providers/*.urls
/usr/lib/evolution/1.4/libcamel.so.*
/usr/libexec/evolution/1.4/camel/camel-index-control
%dir /usr/lib/evolution/1.4/camel-providers
%dir /usr/libexec/evolution/1.4/camel
%attr (2755, root, mail) /usr/libexec/evolution/1.4/camel/camel-lock-helper
%sampler_files


%post
ldconfig
env PATH=$PATH:/usr/bin LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib scrollkeeper-update >/dev/null 2>&1
GCONF_CONFIG_SOURCE=`/usr/bin/gconftool-2 --get-default-source` /usr/bin/gconftool-2 --makefile-install-rule /etc/gconf/schemas/apps_evolution_addressbook.schemas /etc/gconf/schemas/apps_evolution_shell.schemas /etc/gconf/schemas/apps_evolution_summary.schemas /etc/gconf/schemas/evolution-mail.schemas /etc/gconf/schemas/apps_evolution_calendar.schemas
%sampler_post

%postun
env PATH=$PATH:/usr/bin LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib scrollkeeper-update >/dev/null 2>&1

%package -n evolution-pilot
Summary:	Evolution conduits for gnome-pilot
Group:		Communications
Requires:	evolution = %{?epoch:%{epoch}:}%{version}-%{release}
Provides:	ximian-evolution-pilot = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}
Obsoletes:	evolution-pilot1.3

%description -n evolution-pilot
Evolution is the GNOME mailer, calendar, contact manager and
communications tool.  The tools which make up Evolution will
be tightly integrated with one another and act as a seamless
personal information-management tool.

This package contains conduits needed by gnome-pilot to
synchronize your Palm with Evolution.

%sampler_description

%files -n evolution-pilot
%defattr(-, root, root)
/usr/share/*/conduits/*
/usr/lib/*/conduits/*.so


%package -n evolution-devel
Summary:	Libraries and include files for developing Evolution components
Group:		Development/GNOME and GTK+
Requires:	evolution = %{?epoch:%{epoch}:}%{version}-%{release}
Provides:	ximian-evolution-devel = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}
Obsoletes:	evolution1.3

%description -n evolution-devel
Evolution is the GNOME mailer, calendar, contact manager and
communications tool.  The tools which make up Evolution will
be tightly integrated with one another and act as a seamless
personal information-management tool.

This package contains the files necessary to develop applications
using Evolution's libraries.

%sampler_description

%files -n evolution-devel
%defattr(-, root, root)
/usr/include/evolution-1.4/*.h
/usr/include/evolution-1.4/cal-client
/usr/include/evolution-1.4/cal-util
/usr/include/evolution-1.4/e-conduit
/usr/include/evolution-1.4/e-db3util
/usr/include/evolution-1.4/e-util
/usr/include/evolution-1.4/ebook
/usr/include/evolution-1.4/ename
/usr/include/evolution-1.4/importer
/usr/include/evolution-1.4/pas
/usr/include/evolution-1.4/pcs
/usr/include/evolution-1.4/shell
/usr/include/evolution-1.4/widgets
/usr/include/evolution-1.4/wombat
/usr/lib/evolution/1.4/lib*cal*.a
/usr/lib/evolution/1.4/lib*cal*.so
/usr/lib/evolution/1.4/lib*cal*.la
/usr/lib/evolution/1.4/libe*.a
/usr/lib/evolution/1.4/libe*.so
/usr/lib/evolution/1.4/libe*.la
/usr/lib/evolution/1.4/libpas.a
/usr/lib/evolution/1.4/libpcs.a
/usr/lib/evolution/1.4/libversit.a
/usr/lib/evolution/1.4/libversit.so
/usr/lib/evolution/1.4/libversit.la
/usr/lib/evolution/1.4/libwombat.a
/usr/lib/evolution/1.4/libwombat.so
/usr/lib/evolution/1.4/libwombat.la
/usr/lib/pkgconfig/*.pc
%dir /usr/include/evolution-1.4
/usr/include/evolution-1.4/camel
/usr/lib/evolution/1.4/libcamel.so
/usr/lib/evolution/1.4/libcamel.a
/usr/lib/evolution/1.4/libcamel.la

%sampler_package

# $RPM_COMMAND is an environment variable used by the Ximian build
# system to control the build process with finer granularity than RPM
# normally allows.  This specfile will function as expected by RPM if
# $RPM_COMMAND is unset.  If you are not the Ximian build system,
# feel free to ignore it.

%prep
case "${RPM_COMMAND:-all}" in
dist)
%setup  -q -D -n evolution-1.4.3
%patch0 -p 0
    ;;
all)
%setup  -q -n evolution-1.4.3
%patch0 -p 0
%sampler_prep
    ;;
esac

%build
%sampler_build
MAKE=${MAKE:-make}
RPM_COMMAND=${RPM_COMMAND:-all}
DESTDIR=${DESTDIR:-"$RPM_BUILD_ROOT"}
ARCH=%{_target_platform}
export MAKE RPM_COMMAND DESTDIR ARCH
case "$RPM_COMMAND" in
prepare|all)
    ./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --infodir=/usr/share/info --localstatedir=/var \
	    --with-openssl-libs=no --with-openssl-includes=no \
	    --with-db3-includes=/opt/evo-db3/include \
	    --with-db3-libs=/opt/evo-db3/lib \
	    --with-nspr-includes=/usr/include/mozilla-1.4/nspr \
	    --with-nspr-libs=/usr/lib \
	    --with-nss-includes=/usr/include/mozilla-1.4/nss \
	    --with-nss-libs=/usr/lib \
            --enable-nss=yes \
	    --with-openldap \
	    --enable-pilot-conduits=yes --with-pisock=/usr \
            --with-krb4=/usr/kerberos --with-krb5=/usr/kerberos
    ;;
esac
case "$RPM_COMMAND" in
clean|all)
    if [ "/" != "$DESTDIR" ]; then
	rm -rf "$DESTDIR"
    fi
    ;;
esac
case "$RPM_COMMAND" in
build|all)
    ${MAKE}
    ;;
esac

%install
MAKE=${MAKE:-make}
DESTDIR=${DESTDIR:-"$RPM_BUILD_ROOT"}
# export DESTDIR
case "${RPM_COMMAND:-all}" in
install|all)
    ${MAKE} install DESTDIR=${DESTDIR}
    rm -f ${DESTDIR}/usr/lib/*.la
    rm -f ${DESTDIR}/usr/lib/evolution/1.4/*/*.a
    rm -f ${DESTDIR}/usr/lib/evolution/1.4/*/*.la
    rm -f ${DESTDIR}/usr/lib/gnome-pilot/conduits/libe*_conduit.a
    rm -f ${DESTDIR}/usr/lib/gnome-pilot/conduits/libe*_conduit.la
    ;;
esac
%sampler_install -x %{_bindir}/%{name}-%{version}

%clean
DESTDIR=${DESTDIR:-"$RPM_BUILD_ROOT"}
export DESTDIR
case "${RPM_COMMAND:-all}" in
clean|all)
    if [ "/" != "$DESTDIR" ]; then
	rm -rf "$DESTDIR"
    fi
    ;;
esac


%changelog
* Tue Jul 8 2003 Ximian, Inc.

- Version: 1.4.3-0.ximian.6.1
- Summary: New build.
- New automated build.

* Wed Jul 2 2003 Ximian, Inc.

- Version: 1.4.2-0.ximian.6.2
- Summary: New build.
- New automated build.

* Wed Jun 11 2003 Ximian, Inc.

- Version: 1.4.0-0.ximian.6.6
- Summary: New build.
- New automated build.

* Wed May 28 2003 Ximian, Inc.

- Version: 1.3.92-0.ximian.6.3
- Summary: New build.
- New automated build.

* Thu May 22 2003 Ximian, Inc.

- Version: 1.3.91-0.ximian.6.1
- Summary: New build.
- New automated build.

* Tue May 13 2003 Ximian, Inc.

- Version: 1.3.3-0.ximian.6.3
- Summary: New build.
- New automated build.


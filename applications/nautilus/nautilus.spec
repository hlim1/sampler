# RPM specfile for nautilus module
# Generated Tue Jun 10 18:19:26 2003 GMT by Ximian build system
# $Id: nautilus.spec,v 1.3 2003/08/14 22:23:38 liblit Exp $
# from $Id: nautilus.spec,v 1.3 2003/08/14 22:23:38 liblit Exp $

%define nam	nautilus
%define ver	2.2.4
%define licensedir	%{_datadir}/licenses/%{nam}-%{ver}
%define ximrev	5

Name:     	nautilus
Version: 	2.2.4
Release:	0.ximian.6.5.sam.1
Vendor:		UC Berkeley
Distribution:	Sampler
Packager:	Ben Liblit <liblit@cs.berkeley.edu>
Copyright:	GPL/LGPL
BuildRoot:	/var/tmp/%{nam}-%{ver}-root
Docdir:         /usr/share/doc

Source0:	nautilus-2.2.4.tar.gz
Patch0:		nautilus-sidebar-off.patch
Patch1:		nautilus-ximian-defaults.patch
Patch2:		nautilus-2.0.6-samba-imports.patch
Patch3:		nautilus-ximian-menus.patch
Patch4:		nautilus-dircount-no-prompt.patch
Patch5:		nautilus-no-remote-dot-directory.patch
Patch6:		nautilus-monitor-fstab.patch
Patch7:		nautilus-system-vfolder-support.patch
Patch8:		nautilus-printers.patch
Patch9:		nautilus-smb-emblems.patch
Patch10:		nautilus-custom-directory-icons.patch
Patch11:		nautilus-context-icons.patch
Patch12:		nautilus-mailto.patch
Patch13:		nautilus-adapter-auth.patch
Patch14:		nautilus-my-computer-menuitem.patch
Patch15:		nautilus-new-window-location.patch
Patch16:		nautilus-2.1.5-cdburn.patch
Patch17:		nautilus-fixed-size-tblr.patch
Patch18:		nautilus-list-view-drag-position.patch
BuildPrereq:	esound-devel >= 0.2.27
BuildPrereq:	glib2-devel
BuildPrereq:	pango-devel
BuildPrereq:	gtk2-devel
BuildPrereq:	libgnomeui-devel
BuildPrereq:	bonobo-activation-devel >= 2.2.1
BuildPrereq:	libxml2-devel
BuildPrereq:	eel2-devel
BuildPrereq:	gail-devel
BuildPrereq:	gnome-desktop-devel
BuildPrereq:	gnome-vfs2-devel
BuildPrereq:	librsvg2-devel
BuildPrereq:	intltool
BuildPrereq:	cups-devel
BuildPrereq:	gnome-cups-manager-devel
BuildPrereq:	startup-notification-devel
Summary:	Nautilus file manager
Group:		User Interface/Desktop
Requires:	bonobo-activation >= 2.2.1
Requires:	libart_lgpl >= 2.3.10
Requires:	libbonobo >= 2.1.0
Requires:	eel2 >= 2.2.2
Requires:	gnome-desktop >= 2.1.0
Requires:	libgnome >= 2.1.1
Requires:	libgnomeui >= 2.1.1
Requires:	gnome-vfs2 >= 2.1.5
Requires:	ximian-gnome-vfs2
Requires:	librsvg2 >= 2.0.1
Provides:	nautilus2 = %{version}-%{release}
Provides:	ximian-nautilus = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}
Obsoletes:	nautilus-suggested
Obsoletes:	nautilus2
Prereq:	GConf2
Prereq:	scrollkeeper
Conflicts:	nautilus-suggested
Conflicts:	nautilus2 < %{version}-%{release}
Conflicts:	nautilus-devel < %{version}-%{release}
Conflicts:	nautilus-devel > %{version}-%{release}
Conflicts:	nautilus-printers < %{version}-%{release}
Conflicts:	nautilus-printers > %{version}-%{release}
%sampler_tags

%description
				
Nautilus integrates access to files, applications, media,
Internet-based resources and the Web. Nautilus delivers a dynamic and
rich user experience. Nautilus is an free software project developed
under the GNU General Public License and is a core component of the
GNOME desktop project.

%sampler_description


%files
%defattr(-, root, root)
%doc AUTHORS COPYING COPYING.LIB ChangeLog NEWS README
/usr/lib/*.so.*
/usr/bin/*
/usr/libexec/*
/usr/lib/bonobo/libnautilus-history-view.so
/usr/lib/bonobo/libnautilus-notes-view.so
/usr/lib/bonobo/libnautilus-tree-view.so
/usr/lib/bonobo/libnautilus-emblem-view.so
/usr/lib/bonobo/libnautilus-image-properties-view.so
/usr/lib/bonobo/libnautilus-mailto.so
/usr/share/pixmaps/*
/usr/share/applications/*
/usr/lib/bonobo/servers/Nautilus_ComponentAdapterFactory_std.server
/usr/lib/bonobo/servers/Nautilus_Control_throbber.server
/usr/lib/bonobo/servers/Nautilus_shell.server
/usr/lib/bonobo/servers/Nautilus_View_history.server
/usr/lib/bonobo/servers/Nautilus_View_notes.server
/usr/lib/bonobo/servers/Nautilus_View_text.server
/usr/lib/bonobo/servers/Nautilus_View_image_properties.server
/usr/lib/bonobo/servers/Nautilus_View_emblem.server
/usr/lib/bonobo/servers/Nautilus_View_tree.server
/usr/lib/bonobo/servers/Nautilus_Mailto_Component.server
/usr/share/idl/*
/usr/lib/libnautilus-adapter.so
/usr/share/nautilus
/usr/*/locale/*/LC_MESSAGES/*
/usr/share/gnome-2.0/ui/*
/etc/gnome-vfs-2.0/modules/*
/etc/gnome-vfs-2.0/vfolders/*
/etc/gconf/schemas/*
/etc/X11/*
%sampler_files


%post
GCONF_CONFIG_SOURCE=`/usr/bin/gconftool-2 --get-default-source` /usr/bin/gconftool-2 --makefile-install-rule /etc/gconf/schemas/apps_nautilus_preferences.schemas
%sampler_post

ldconfig

%postun
ldconfig

%package -n nautilus-printers
Summary:	Printer view for Nautilus
Group:		User Interface/Desktop
Requires:	nautilus = %{version}-%{release}
Requires:	cups
Provides:	ximian-nautilus-printers = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}

%description -n nautilus-printers
This package provides a view for managing printers in nautilus.

%sampler_description

%files -n nautilus-printers
%defattr(-, root, root)
/usr/lib/bonobo/libnautilus-printers-view.so
/usr/lib/bonobo/servers/Nautilus_View_printers.server


%package -n nautilus-devel
Summary:	Libraries and include files for developing Nautilus components
Group:		Development/Libraries
Requires:	nautilus = %{version}-%{release}
Requires:	eel2-devel
Requires:	librsvg2-devel
Requires:	libgnomeui-devel
Provides:	nautilus2-devel = %{version}-%{release}
Provides:	ximian-nautilus-devel = %{?epoch:%{epoch}:}%{version}-%{?ximrev:%{ximrev}}%{!?ximrev:%{release}}
Obsoletes:	nautilus2-devel
Conflicts:	nautilus2-devel < %{version}-%{release}

%description -n nautilus-devel
This package provides the necessary development libraries and include
files to allow you to develop Nautilus components.

%sampler_description

%files -n nautilus-devel
%defattr(-, root, root)
/usr/include/*
/usr/lib/*.a
/usr/lib/libnautilus-private.so
/usr/lib/libnautilus.so
/usr/lib/pkgconfig/*


%sampler_package


# $RPM_COMMAND is an environment variable used by the Ximian build
# system to control the build process with finer granularity than RPM
# normally allows.  This specfile will function as expected by RPM if
# $RPM_COMMAND is unset.  If you are not the Ximian build system,
# feel free to ignore it.

%prep
case "${RPM_COMMAND:-all}" in
dist)
%setup  -q -D -n nautilus-2.2.4
    ;;
all)
%setup  -q -n nautilus-2.2.4
    ;;
esac
case "${RPM_COMMAND:-all}" in
dist|all)
%patch -p1 -P 0
%patch -p1 -P 1
%patch -p1 -P 2
%patch -p1 -P 3
%patch -p1 -P 4
%patch -p1 -P 5
%patch -p1 -P 6
%patch -p1 -P 7
%patch -p1 -P 8
%patch -p1 -P 9
%patch -p1 -P 10
%patch -p1 -P 11
%patch -p1 -P 12
%patch -p1 -P 13
%patch -p1 -P 14
%patch -p1 -P 15
%patch -p1 -P 16
%patch -p1 -P 17
%patch -p1 -P 18
%sampler_prep
    ;;
esac

%build
%define sampler_cc_flags --threads
%sampler_prebuild
MAKE=${MAKE:-make}
RPM_COMMAND=${RPM_COMMAND:-all}
DESTDIR=${DESTDIR:-"$RPM_BUILD_ROOT"}
ARCH=%{_target_platform}
export MAKE RPM_COMMAND DESTDIR ARCH
case "$RPM_COMMAND" in
prepare|all)
    aclocal-1.4 ${ACLOCAL_FLAGS}; libtoolize --force --copy; aclocal-1.4 ${ACLOCAL_FLAGS}; automake-1.4 --gnu --add-missing --include-deps; autoconf; ./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --infodir=/usr/share/info --localstatedir=/var --enable-static
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
    ${MAKE} DESTDIR=${DESTDIR} install; rm -rf ${DESTDIR}/usr/lib/*.la
rm -f ${DESTDIR}/etc/X11/starthere/applications.desktop
rm -f ${DESTDIR}/etc/X11/starthere/preferences.desktop
rm -f ${DESTDIR}/etc/X11/starthere/serverconfig.desktop
rm -f ${DESTDIR}/etc/X11/starthere/sysconfig.desktop
# the next four rm commands work around <http://bugzilla.ximian.com/show_bug.cgi?id=46634>
rm ${DESTDIR}/usr/lib/bonobo/*.la
rm ${DESTDIR}/usr/lib/bonobo/*.a
rm ${DESTDIR}/usr/share/control-center-2.0/capplets/nautilus-file-management-properties.desktop
rm ${DESTDIR}/usr/share/gnome/network/nautilus-server-connect.desktop
%sampler_install
	    
    ;;
esac

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
* Tue Aug 12 2003 Ben Liblit <liblit@cs.berkeley.edu> 2.2.4-0.ximian.6.5.sam.1

- Added hooks for sampled instrumentation.

* Tue Jun 10 2003 Ximian, Inc.

- Version: 2.2.4-0.ximian.6.5
- Summary: New build.
- New automated build.

* Tue Apr 29 2003 Ximian, Inc.

- Version: 2.2.3.1-0.ximian.5
- Summary: New build.
- New automated build.

* Thu Mar 20 2003 Ximian, Inc.

- Version: 2.2.2-0.ximian.3
- Summary: New build.
- New automated build.

* Wed Feb 19 2003 Ximian, Inc.

- Version: 2.2.1-1.ximian.2
- Summary: New build.
- New automated build.

* Fri Jan 24 2003 Ximian, Inc.

- Version: 2.2.0.1-1.ximian.1
- Summary: New build.
- New automated build.

* Mon Sep 16 2002 Ximian, Inc.

- Version: 2.0.7-1.ximian.1
- Summary: New build.
- New automated build.

* Thu Aug 29 2002 Ximian, Inc.

- Version: 2.0.6-1.ximian.1
- Summary: New build.
- New automated build.

* Mon Aug 26 2002 Ximian, Inc.

- Version: 2.0.4-1.ximian.1
- Summary: New build.
- New automated build.

* Fri Aug 9 2002 Ximian, Inc.

- Version: 2.0.3-1.ximian.1
- Summary: New build.
- New automated build.

* Fri Jul 26 2002 Ximian, Inc.

- Version: 2.0.2-1.ximian.1
- Summary: New build.
- New automated build.

* Wed Jul 24 2002 Ximian, Inc.

- Version: 2.0.1-1.ximian.1
- Summary: New build.
- New automated build.

* Mon Jul 15 2002 Ximian, Inc.

- Version: 2.0.0-12.ximian.1
- Summary: New build.
- New automated build.

* Wed Jun 19 2002 Ximian, Inc.

- Version: 1.0.6-15.ximian.14
- Summary: New build.
- New automated build.


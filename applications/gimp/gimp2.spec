%define _prefix /usr/lib/gimp2
%define sampler_datadir /usr/share/sampler
%define sampler_libdir /usr/lib/sampler

Summary:        The GNU Image Manipulation Program.
Name:           gimp2
Version:        1.3.18
Release:        0.fdr.5.rh90.sam.1
Epoch:          0
URL:            http://www.gimp.org
License:        GPL
Group:          Applications/Multimedia
Source0:        ftp://ftp.gimp.org/pub/gimp/v1.3/v1.3.18/gimp-1.3.18.tar.bz2
Source1:        gimp2.desktop
Source2:        gimp2.png
Source3:        gimp2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	glib2-devel >= 0:2.2.0
BuildRequires:	gtk2-devel >= 0:2.2.0
BuildRequires:	gail-devel >= 0:0.17
BuildRequires:  libtiff-devel
BuildRequires:  libjpeg-devel
BuildRequires:  libpng-devel
BuildRequires:  gtkhtml2-devel
BuildRequires:  gimp-print-devel
BuildRequires:  libmng-devel
BuildRequires:  aalib-devel
BuildRequires:  libexif-devel
BuildRequires:  python-devel
BuildRequires:  pygtk2-devel
BuildRequires:  gtk-doc
BuildRequires:  docbook-style-xsl
BuildRequires:  libtool
BuildRequires:  desktop-file-utils
BuildRequires:  gettext
Provides:       gimp-%{version}
Obsoletes:      gimp13
%{?sampler_tags:%sampler_tags -s 4}
Packager:	Ben Liblit <liblit@cs.berkeley.edu>
Vendor:		UC Berkeley
Distribution:	Sampler

%description
The GIMP is the GNU Image Manipulation Program. It is a freely distributed
piece of software suitable for such tasks as photo retouching, image
composition and image authoring. 

%{?sampler_description}

%package        devel
Summary:        GIMP plugin and extension development kit
Group:          Development/Libraries
Requires:       glib2-devel >= 0:2.2.0
Requires:       gtk2-devel >= 0:2.2.0
Requires:       pkgconfig
Requires:       %{name} = %{epoch}:%{version}-%{release}
%description    devel
Static libraries and header files for writing GIMP plugins and extensions.

%{?sampler_description}

%{sampler_package}

#---------------------------------------------------------------------

%prep
%setup -q -n gimp-%{version}
%{?sampler_prep}

#---------------------------------------------------------------------

%build
%{?sampler_prebuild}
%configure --enable-python  --enable-gtk-doc
make

#---------------------------------------------------------------------

%install
rm -rf ${RPM_BUILD_ROOT}
make install DESTDIR=${RPM_BUILD_ROOT}

install -p -D -m644 %{SOURCE1} ${RPM_BUILD_ROOT}/usr/share/applications/%{name}.desktop
install -p -D -m644 %{SOURCE2} ${RPM_BUILD_ROOT}/usr/share/pixmaps/%{name}.png
install -p -D -m755 %{SOURCE3} ${RPM_BUILD_ROOT}/usr/bin/gimp2

desktop-file-install --vendor fedora --delete-original \
  --dir ${RPM_BUILD_ROOT}%{_datadir}/applications      \
  --add-category X-Fedora                              \
  --add-category Application                           \
  --add-category Graphics                              \
  ${RPM_BUILD_ROOT}/usr/share/applications/%{name}.desktop

mv ${RPM_BUILD_ROOT}%{_datadir}/applications/* ${RPM_BUILD_ROOT}/usr/share/applications/
find ${RPM_BUILD_ROOT} -type f -name "*.la" -exec rm -f {} ';'

%define sampler_wrapped %{_bindir}/gimp-1.3
%{?sampler_install}
echo 'samplerinfo package includes %{_sampler_libdir}/sites/*'
ls ${RPM_BUILD_ROOT}%{_sampler_libdir}/sites/*

#---------------------------------------------------------------------

%clean
rm -rf ${RPM_BUILD_ROOT}

#---------------------------------------------------------------------

%files
%defattr(-,root,root,-)
%doc AUTHORS COPYING ChangeLog NEWS README TODO.xml docs/quick_reference.ps
%dir /usr/lib/gimp2
/usr/share/applications/fedora-%{name}.desktop
/usr/share/pixmaps/%{name}.png
/usr/bin/gimp2
%dir %{_bindir}
%dir %{_libdir}
%dir %{_datadir}
%dir %{_datadir}/locale
%{_bindir}/*
%{_libdir}/*.so.*
%{_libdir}/gimp
%{_datadir}/gimp
%{_datadir}/locale/*
%{_sysconfdir}/gimp
%{_mandir}/man1/*
%{_mandir}/man5/*
%{sampler_files}

%files devel
%defattr(-,root,root,-)
%doc HACKING
%{_libdir}/*.a
%{_libdir}/*.so
%{_datadir}/aclocal/*.m4
%{_datadir}/gtk-doc
%{_libdir}/pkgconfig/*
%{_includedir}

#---------------------------------------------------------------------

%changelog
* Sun Aug 17 2003 Ben Liblit <liblit@cs.berkeley.edu> - 1.3.18-0.fdr.5.rh90.sam.1
- Added hooks for sampled instrumentation.

* Sun Aug 17 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.18-0.fdr.5
- Moved %%{_mandir}/man5/ into main package.
- Tweaked desktop entry.
- Ownership of directories.
- devel Req pkgconfig

* Thu Aug 14 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.18-0.fdr.4
- Re-added --enable-gtk-doc.
- BuildReq docbook-style-xsl.

* Thu Aug 14 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.18-0.fdr.3
- Dropped %%{?_smp_mflags}.
- Dropped --enable-gtk-doc.

* Wed Aug 13 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.18-0.fdr.2
- added --enable-python --enable-gtk-doc.
- BuildReq python-devel.
- BuildReq pygtk2-devel.
- BuildReq libtool.
- BuildReq gtk-doc.

* Mon Aug 11 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.18-0.fdr.1
- Updated to 1.3.18.

* Wed Jul 30 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.17-0.fdr.2
- BuildReq libexif-devel.

* Fri Jul 25 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.17-0.fdr.1
- Renamed to gimp2.
- Added Obsoletes: gimp13.
- Added Provides gimp-%%{version}
- Changed prefix to /usr/lib/gimp2.
- Changed gtk2/glib2 BuildReqs to 2.2.
- BuildReq libmng-devel.
- BuildReq aalib-devel.

* Fri Jul 18 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.16-0.fdr.2
- owned directories.
- explicit epochs.
- readded Epoch: 0.

* Fri Jun 27 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.16-0.fdr.1
- Updated to 1.3.16.

* Thu Jun 12 2003 Phillip Compton <pcompton at proteinmedia dot com> - 1.3.15-0.fdr.1
- Updated to 1.3.15.
- buildroot -> RPM_BUILD_ROOT.
- Removed Epoch:0.

* Fri Apr 18 2003 Warren Togami <warren@togami.com> - 0:1.3.14-0.fdr.2
- BuildRequires gettext

* Tue Apr 01 2003 Phillip Compton <pcompton[AT]proteinmedia.com> - 0:1.3.14-0.fdr.1
- Updated to 1.3.14.
- Added missing BuildRequires.

* Tue Apr 01 2003 Phillip Compton <pcompton[AT]proteinmedia.com> - 0:1.3.13-0.fdr.2
- Added Epoch:0.
- Changed prefix to /usr/lib/gimp13.
- Added startup script.
- Added desktop-file-utils to BuildRequires.
- Changed category to X-Fedora-Extra.

* Mon Mar 24 2003 Phillip Compton <pcompton[AT]proteinmedia.com> - 1.3.13-0.fdr.1
- Initial RPM release.

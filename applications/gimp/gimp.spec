# $Id: gimp.spec,v 1.1 2003/08/15 23:56:43 liblit Exp $

%define majver 1.3
%define minver 18

%define desktop_vendor freshrpms

Summary: The GNU Image Manipulation Program.
Name: gimp
#Version: %{majver}.%{minver}
Version: 1.3.18
Release: 1.fr.sam.1
Epoch: 1
License: GPL, LGPL
Group: Applications/Graphics
Source: ftp://ftp.gimp.org/pub/gimp/v%{majver}/%{name}-%{version}.tar.bz2
URL: http://www.gimp.org/
Requires: gtk2 >= 2.0.0, gtkhtml2, aalib, libexif
BuildRequires: gtk2-devel >= 2.0.0, gtkhtml2-devel, pkgconfig, aalib-devel
BuildRequires: libexif-devel
%{!?_without_freedesktop:BuildRequires: desktop-file-utils}
BuildRoot: %{_tmppath}/%{name}-root
Packager:	Ben Liblit <liblit@cs.berkeley.edu>
Vendor:		UC Berkeley
Distribution:	Sampler
%{?sampler_tags}

%description
The GIMP (GNU Image Manipulation Program) is a powerful image
composition and editing program, which can be extremely useful for
creating logos and other graphics for Web pages.  The GIMP has many of
the tools and filters you would expect to find in similar commercial
offerings, and some interesting extras as well. The GIMP provides a
large image manipulation toolbox, including channel operations and
layers, effects, sub-pixel imaging and anti-aliasing, and conversions,
all with multi-level undo.

The GIMP includes a scripting facility, but many of the included
scripts rely on fonts that we cannot distribute.  The GIMP FTP site
has a package of fonts that you can install by yourself, which
includes all the fonts needed to run the included scripts.  Some of
the fonts have unusual licensing requirements; all the licenses are
documented in the package.  Get
ftp://ftp.gimp.org/pub/gimp/fonts/freefonts-0.10.tar.gz and
ftp://ftp.gimp.org/pub/gimp/fonts/sharefonts-0.10.tar.gz if you are so
inclined.  Alternatively, choose fonts which exist on your system
before running the scripts.

Available rpmbuild rebuild options :
--without : freedesktop

%{?sampler_description}


%package devel
Summary: GIMP plugin and extension development kit.
Group: Applications/Graphics
Requires: gtk2-devel >= 2.0.0, pkgconfig

%description devel
The gimp-devel package contains the static libraries and header files
for writing GNU Image Manipulation Program (GIMP) plug-ins and
extensions.

Install gimp-devel if you're going to create plug-ins and/or
extensions for the GIMP.

%{?sampler_description}


%{?sampler_package}


%prep
%setup -q
%{?sampler_prep}

%build
%{?sampler_prebuild}
%configure \
        --enable-default-binary \
        --disable-print
make %{_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}

# We don't want those
find %{buildroot}%{_libdir} -name "*.la" | xargs rm -f

# Execute find_lang for all components and merge the resulting lists
rm -f global.lang
for what in gimp20 gimp20-libgimp gimp20-std-plug-ins gimp20-script-fu; do
        %find_lang ${what}
        cat ${what}.lang >> global.lang
done

# Install desktop entry
%if %{!?_without_freedesktop:1}%{?_without_freedesktop:0}
mkdir -p %{buildroot}%{_datadir}/applications
desktop-file-install --vendor %{desktop_vendor} --delete-original \
  --dir %{buildroot}%{_datadir}/applications                      \
  --add-category X-Red-Hat-Base                                   \
  --add-category Application                                      \
  --add-category Graphics                                         \
  %{buildroot}%{_datadir}/%{name}/%{majver}/misc/%{name}.desktop
%else
install -D -m644 \
  %{buildroot}%{_datadir}/%{name}/%{majver}/misc/%{name}.desktop \
  %{buildroot}/etc/X11/applnk/Graphics/%{name}.desktop
%endif

%{?sampler_install}


%clean
rm -rf %{buildroot}

%post
/sbin/ldconfig
%{?sampler_post}

%postun -p /sbin/ldconfig


%files -f global.lang
%defattr (-, root, root)
%doc AUTHORS ChangeLog* COPYING MAINTAINERS NEWS README README.i18n
%doc docs/*.txt
%dir %{_sysconfdir}/%{name}/%{majver}
%config %{_sysconfdir}/%{name}/%{majver}/*
%{_bindir}/*
%{_libdir}/*.so.*
%dir %{_libdir}/%{name}
%dir %{_libdir}/%{name}/%{majver}
%{_libdir}/%{name}/%{majver}/environ
%dir %{_libdir}/%{name}/%{majver}/modules
%{_libdir}/%{name}/%{majver}/modules/*.so
%{_libdir}/%{name}/%{majver}/plug-ins
%{!?_without_freedesktop:%{_datadir}/applications/%{desktop_vendor}-%{name}.desktop}
%{_datadir}/%{name}
%doc %{_datadir}/gtk-doc/html/*
%{_mandir}/man1/*
%{?_without_freedesktop:/etc/X11/applnk/Graphics/%{name}.desktop}
%{?sampler_files}

%files devel
%defattr (-, root, root)
%doc HACKING PLUGIN_MAINTAINERS
%{_includedir}/*
%{_libdir}/*.a
%{_libdir}/*.so
%dir %{_libdir}/%{name}
%dir %{_libdir}/%{name}/%{majver}
%dir %{_libdir}/%{name}/%{majver}/modules
%{_libdir}/%{name}/%{majver}/modules/*.a
%{_libdir}/pkgconfig/*
%{_datadir}/aclocal/*
%{_mandir}/man5/*

%changelog
* Fri Aug 15 2003 Ben Liblit <liblit@cs.berkeley.edu> 1:18-1.fr.sam.1
- Added hooks for sampled instrumentation.

* Mon Aug 11 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.18.
- Update the lang files from gimp14 to gimp20.

* Fri Jul 25 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.17.

* Fri Jul 25 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Rebuild against new libexif.

* Fri Jun 27 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.16.

* Wed Jun 11 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.15.
- Added Epoch 1 to match existing Red Hat packages.

* Tue Apr 15 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.14.

* Mon Mar 31 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Rebuilt for Red Hat Linux 9.

* Sun Mar 23 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Update to 1.3.13.

* Fri Feb 14 2003 Matthias Saou <matthias.saou@est.une.marmotte.net>
- Reinvented the wheel, but packaged 1.3.11.

* Fri Apr 14 2000 Matt Wilson <msw@redhat.com>
- include subdirs in the help find
- remove gimp-help-files generation
- both gimp and gimp-perl own prefix/lib/gimp/1.1/plug-ins
- both gimp and gimp-devel own prefix/lib/gimp/1.1 and
  prefix/lib/gimp/1.1/modules

* Thu Apr 13 2000 Matt Wilson <msw@redhat.com>
- 1.1.19
- get all .mo files

* Wed Jan 19 2000 Gregory McLean <gregm@comstar.net>
- Version 1.1.15

* Wed Dec 22 1999 Gregory McLean <gregm@comstar.net>
- Version 1.1.14
- Added some auto %files section generation scriptlets



ifndef _cdbs_bootstrap
_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
endif

ifndef _cdbs_rules_sampler
_cdbs_rules_sampler := 1


include $(_cdbs_rules_path)/debhelper.mk$(_cdbs_makefile_suffix)


########################################################################


SAMPLER_SCHEMES = $(error SAMPLER_SCHEMES undefined)
SAMPLER_CC_FLAGS_SCHEMES = $(foreach scheme, $(SAMPLER_SCHEMES), --sampler-scheme=$(scheme))
SAMPLER_CC_FLAGS = --sample $(SAMPLER_CC_FLAGS_SCHEMES)
SAMPLER_CC = sampler-cc
CC = $(SAMPLER_CC) $(SAMPLER_CC_FLAGS)

SAMPLER_TOOLS = /home/liblit/research/sampler-1.1/tools

SAMPLER_NAME = $(cdbs_curpkg)
SAMPLER_VERSION = $(firstword $(subst -, , $(DEB_NOEPOCH_VERSION)))
SAMPLER_RELEASE = $(shell echo '$(DEB_NOEPOCH_VERSION)' | sed 's/^[^-]*-//')
SAMPLER_SPARSITY = $(error SAMPLER_SPARSITY undefined)
SAMPLER_REPORTING_HOST = $(error SAMPLER_REPORTING_HOST undefined)
SAMPLER_REPORTING_URL = https://$(SAMPLER_REPORTING_HOST)/cgi-bin/sampler-upload
SAMPLER_ROOT = $(CURDIR)/debian/$(cdbs_curpkg)

SAMPLER_WRAP_PACKAGES = $(basename $(notdir $(wildcard debian/*.sampler-wrap)))
SAMPLER_NONWRAP_PACKAGES = $(filter-out $(SAMPLER_WRAP_PACKAGES), $(DEB_ARCH_PACKAGES))


########################################################################


common-install-prehook-arch:: sampler-clean

sampler-clean::
	rm -rf debian/$(DEB_ARCH_PACKAGES:=-samplerinfo)
	rm -f debian/sampler-control. debian/sampler-control
.PHONY: sampler-clean


########################################################################


$(SAMPLER_WRAP_PACKAGES:%=sampler-gconf/%) :: sampler-gconf/%:
	'$(SAMPLER_TOOLS)/install-gconf'		\
	  --name='$(SAMPLER_NAME)'			\
	  --sparsity='$(SAMPLER_SPARSITY)'		\
	  --reporting-url='$(SAMPLER_REPORTING_URL)'	\
	  --install='$(SAMPLER_ROOT)'
	chown 0:0 '$(SAMPLER_ROOT)'/etc/gconf/schemas/sampler-*.schemas

.PHONY: sampler-gconf/%

$(SAMPLER_WRAP_PACKAGES:%=binary-install/%) :: binary-install/%: sampler-gconf/%
	$(if $(_cdbs_class_gnome), , dh_gconf -p$(cdbs_curpkg) $(DEB_DH_GCONF_ARGS))


########################################################################


$(SAMPLER_WRAP_PACKAGES:%=sampler-wrap/%) :: sampler-wrap/%:
	'$(SAMPLER_TOOLS)/install-wrappers'		\
	  --name='$(SAMPLER_NAME)'			\
	  --version='$(SAMPLER_VERSION)'		\
	  --release='$(SAMPLER_RELEASE)'		\
	  --install='$(SAMPLER_ROOT)'			\
	  --						\
	  `cat debian/$(@F).sampler-wrap`

$(SAMPLER_NONWRAP_PACKAGES:%=sampler-wrap/%) :: sampler-wrap/%:

.PHONY: sampler-wrap/%


########################################################################


$(DEB_ARCH_PACKAGES:%=sampler-info/%) :: sampler-info/%: sampler-wrap/%
	'$(SAMPLER_TOOLS)/find-sampler-info'	\
	  --extract='$(SAMPLER_ROOT)'		\
	  --save='$(SAMPLER_ROOT)-samplerinfo'
	chmod -R 0644 '$(SAMPLER_ROOT)-samplerinfo'
	chown -R 0:0 '$(SAMPLER_ROOT)-samplerinfo'

.PHONY: sampler-info/%

$(DEB_ARCH_PACKAGES:%=binary-post-install/%) :: binary-post-install/%: sampler-info/%


########################################################################


$(SAMPLER_WRAP_PACKAGES:%=binary-predeb/%) :: binary-predeb/%: sampler-depends/%

.PHONY: sampler-depends/%

$(SAMPLER_WRAP_PACKAGES:%=sampler-depends/%) :: $(SAMPLER_TOOLS)/add-depends sampler-depends/%
	$< $(cdbs_curpkg)


########################################################################


debian/sampler-control: $(SAMPLER_TOOLS)/build-control debian/control
	$< $(DEB_ARCH_PACKAGES) >$@.
	mv $@. $@

$(DEB_ARCH_PACKAGES:%=binary/%-samplerinfo) :: binary/%-samplerinfo : debian/sampler-control install/%
	mkdir debian/$(cdbs_curpkg)/DEBIAN
	dpkg-gencontrol -isp -p$(cdbs_curpkg) -cdebian/sampler-control -Pdebian/$(cdbs_curpkg)
	cd debian/$(cdbs_curpkg) && find . -type f ! -regex '.*/DEBIAN/.*' -printf '%P\0' | xargs -r0 md5sum > DEBIAN/md5sums
	chmod 0644 debian/$(cdbs_curpkg)/DEBIAN/md5sums
	chown 0:0 debian/$(cdbs_curpkg)/DEBIAN/md5sums
	test -s debian/$(cdbs_curpkg)/DEBIAN/md5sums || rm -f debian/$(cdbs_curpkg)/DEBIAN/md5sums
	dpkg-deb --build debian/$(cdbs_curpkg) ..

.PHONY: binary/%-samplerinfo

binary-arch: $(DEB_ARCH_PACKAGES:%=binary/%-samplerinfo)


########################################################################


endif

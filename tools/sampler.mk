ifndef _cdbs_rules_sampler
_cdbs_rules_sampler := 1

include $(_cdbs_rules_path)/debhelper.mk$(_cdbs_makefile_suffix)

SAMPLER_SCHEMES = $(error SAMPLER_SCHEMES undefined)
SAMPLER_CC_FLAGS_SCHEMES = $(foreach scheme, $(SAMPLER_SCHEMES), --sampler-scheme=$(scheme))
SAMPLER_CC_FLAGS = --sample $(SAMPLER_CC_FLAGS_SCHEMES)
SAMPLER_CC = sampler-cc
CC = $(SAMPLER_CC) $(SAMPLER_CC_FLAGS)

SAMPLER_TEMPLATES = /home/liblit/research/sampler-1.1/launcher/templates

SAMPLER_NAME = $(DEB_SOURCE_PACKAGE)
SAMPLER_VERSION = $(firstword $(subst -, , $(DEB_NOEPOCH_VERSION)))
SAMPLER_RELEASE = $(shell echo '$(DEB_NOEPOCH_VERSION)' | sed 's/^[^-]*-//')
SAMPLER_SPARSITY = $(error SAMPLER_SPARSITY undefined)
SAMPLER_REPORTING_HOST = $(error SAMPLER_REPORTING_HOST undefined)
SAMPLER_REPORTING_URL = https://$(SAMPLER_REPORTING_HOST)/cgi-bin/sampler-upload
SAMPLER_ROOT = $(DEB_DESTDIR:%/=%)
SAMPLER_WRAP = $(error SAMPLER_WRAP undefined)

common-install-arch:: sampler-install-impl

sampler-install-impl:: common-install-impl
	$(SAMPLER_TEMPLATES)/install-wrappers		\
	  --name='$(SAMPLER_NAME)'			\
	  --version='$(SAMPLER_VERSION)'		\
	  --release='$(SAMPLER_RELEASE)'		\
	  --sparsity='$(SAMPLER_SPARSITY)'		\
	  --reporting-url='$(SAMPLER_REPORTING_URL)'	\
	  --root='$(SAMPLER_ROOT)'			\
	  $(SAMPLER_WRAP)
	$(if $(_cdbs_class_gnome), , dh_gconf -p$(cdbs_curpkg) $(DEB_DH_GCONF_ARGS))

endif

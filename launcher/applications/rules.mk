pwd := $(shell pwd)
rpmenv := RPM_TOPDIR='$(pwd)' HOME='$(dir $(pwd))'

name ?= $(error name not set)
version ?= $(error version not set)
release ?= $(error release not set)
sam_release ?= $(error sam_release not set)
scheme ?= $(error scheme not set)

spec = $(name).spec
cpu := $(shell rpm -E %{_target_cpu})
sam_rpm = RPMS/$(cpu)/$(name)-samplerinfo-$(version)-$(release).sam.$(sam_release).$(cpu).rpm
srpm = $(name)-$(version)-$(release).src.rpm
sam_srpm = SRPMS/$(name)-$(version)-$(release).sam.$(sam_release).src.rpm

sampler_extras := $(name)-sampler.tar.gz

rpmbuild := $(top_builddir)/tools/rpmbuild


########################################################################


EXTRA_DIST :=					\
	$(name)-sampler.schemas			\
	$(name).spec				\
	interface.glade				\
	interface.gladep


########################################################################


schemas := $(name)-sampler.schemas
dtd := gconf-1.0.dtd

TESTS := $(schemas)
XMLLINT := @XMLLINT@
TESTS_ENVIRONMENT := $(XMLLINT) --valid --noout


check-am: $(dtd)
$(dtd): ../$(dtd)
	$(LN_S) $< $@


########################################################################


$(rpmbuild): force
	$(MAKE) -C $(@D) $(@F)

unpack: SPECS/$(spec)
.PHONY: unpack
SPECS/$(spec): $(srpm)
	$(rpmenv) rpm -i $<

$(sampler_extras): config.in $(name)-sampler.schemas interface.glade wrapper.in
	tar czf $@ $^

config.in wrapper.in: %: ../%
	cp $< $@

SOURCES/$(sampler_extras): SOURCES/%: % SOURCES/.stamp
	cp $< $@

srpm: $(sam_srpm)
.PHONY: srpm
$(sam_srpm): $(spec) $(rpmbuild) SOURCES/$(sampler_extras) SPECS/$(spec) SRPMS/.stamp
	$(rpmenv) $(rpmbuild) '$(scheme)' -bs $<

rpm: $(sam_rpm)
.PHONY: rpm
$(sam_rpm): $(sam_srpm) $(rpmbuild) BUILD/.stamp RPMS/.stamp
	$(rpmenv) $(rpmbuild) '$(scheme)' --rebuild $<
	[ -e $@ ]

.PHONY: bi
bi: $(sam_rpm) $(rpmbuild) BUILD/.stamp RPMS/.stamp
	cp $(spec) SPECS
	$(rpmenv) $(rpmbuild) '$(scheme)' -bi --short-circuit SPECS/$(spec)


BUILD/.stamp SOURCES/.stamp SRPMS/.stamp: %/.stamp:
	[ -d $* ] || mkdir $*
	touch $@

RPMS/.stamp: %/.stamp:
	[ -d $*/$(cpu) ] || mkdir -p $*/$(cpu)
	touch $@


mostlyclean-local:
	rm -rf BUILD RPMS SOURCES SPECS SRPMS


force:
.PHONY: force

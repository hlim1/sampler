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
	interface.gladep			\
	wrapper


########################################################################


schemas := $(name)-sampler.schemas
dtd := gconf-1.0.dtd

TESTS := $(schemas)
XMLLINT := @XMLLINT@
TESTS_ENVIRONMENT := $(XMLLINT) --valid --noout


check-am: $(dtd)
$(dtd): ../$(dtd)
	$(LN_S) $< $@


config: $(srcdir)/../config.in
	sed					\
	  -e 's/@''name@/${name}/g'		\
	  -e 's/@''version@/${version}/g'	\
	  -e 's/@''release@/${release}/g'	\
	  -e 's/@''scheme@/${scheme}/g'		\
	<$< >$@.tmp
	mv $@.tmp $@


########################################################################


$(rpmbuild): force
	$(MAKE) -C $(@D) $(@F)
force:
.PHONY: force


unpack: SPECS/$(spec)
.PHONY: unpack
SPECS/$(spec): $(srpm)
	$(rpmenv) rpm -i $<

wrapper: ../wrapper
	cp $< $@

$(sampler_extras): config $(name)-sampler.schemas interface.glade wrapper
	tar czf $@ $^

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

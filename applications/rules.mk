pwd := $(shell pwd)
rpmenv = RPM_TOPDIR='$(pwd)' HOME='$(dir $(pwd))'

name ?= $(error name not set)
version ?= $(error version not set)
release ?= $(error release not set)
sam_release ?= $(error sam_release not set)
scheme ?= $(error scheme not set)

spec = $(name).spec
cpu := $(shell rpm -E %{_target_cpu})


########################################################################


schema = $(name)-sampler.schemas

overlay_files :=				\
	$(schema)				\
	interface.glade				\
	../config.in				\
	../wrapper.in

overlay = $(name)-sampler.tar.gz
overlay: $(overlay)
.PHONY: overlay
$(overlay): $(overlay_files)
	rm -rf sampler
	mkdir sampler
	cp $^ sampler
	tar czf $@ sampler
	rm -rf sampler


EXTRA_DIST =					\
	interface.glade				\
	interface.gladep			\
	$(schema)				\
	$(spec)					\
	$(extra_sources)


########################################################################


rpmbuild = $(top_builddir)/tools/rpmbuild
$(rpmbuild): force
	$(MAKE) -C $(@D) $(@F)

srpm = $(name)-$(version)-$(release).src.rpm
sam_srpm = SRPMS/$(name)-$(version)-$(release).sam.$(sam_release).src.rpm
srpm: $(sam_srpm)
.PHONY: srpm
$(sam_srpm): $(spec) $(overlay) $(extra_sources) $(srpm) $(rpmbuild) SRPMS/.stamp
	$(rpmenv) rpm -i $(srpm)
	cp $(overlay) $(extra_sources) SOURCES
	cp $(spec) SPECS
	$(rpmenv) $(rpmbuild) '$(scheme)' -bs $<

sam_rpm = RPMS/$(cpu)/$(name)-samplerinfo-$(version)-$(release).sam.$(sam_release).$(cpu).rpm
rpm: $(sam_rpm)
.PHONY: rpm
$(sam_rpm): $(sam_srpm) $(rpmbuild) BUILD/.stamp RPMS/.stamp
	$(rpmenv) $(rpmbuild) '$(scheme)' --rebuild $<
	[ -e $@ ]


########################################################################


BUILD/.stamp SOURCES/.stamp SRPMS/.stamp: %/.stamp:
	[ -d $* ] || mkdir $*
	touch $@

RPMS/.stamp: %/.stamp:
	[ -d $*/$(cpu) ] || mkdir -p $*/$(cpu)
	touch $@


.PHONY: bi
bi: $(spec) $(rpmbuild) BUILD/.stamp RPMS/.stamp
	cp $(spec) SPECS
	$(rpmenv) $(rpmbuild) '$(scheme)' -bi --short-circuit SPECS/$(spec)


MOSTLYCLEANFILES = $(overlay)

mostlyclean-local:
	rm -rf sampler BUILD RPMS SOURCES SPECS SRPMS


force:
.PHONY: force

builds := always-none always-all sample-all


########################################################################


all: pristine-stamp $(builds:=/src/ccrypt)

pristine-stamp: build-pristine always-none/src/ccrypt
	./$^
	touch $@

clean:: $(builds:=/clean)
	rm -f pristine-stamp
	rm -rf cyphertext pristine

$(builds:=/src/ccrypt): %/src/ccrypt: %/Makefile force
	make -C $(dir $(@D))

$(builds:=/Makefile):
	cd $(@D) && CC=$$PWD/cc ../src/configure

$(builds:=/clean):
	make -C $(@D) $(@F)
.PHONY: $(builds:=/clean)


########################################################################


sparsities := 100 1000 10000 1000000
seeds := 1 2 3 4
sampleTimes := $(sparsities:%=times/sample-all-%.times)
alwaysTimes := $(patsubst %, times/always-%.times, none all)
times := $(alwaysTimes) $(sampleTimes)

times: collated-times.txt
.PHONY: times

collated-times.txt: collate-times $(times)
	./$< times >times/$@
	cp times/$@ $@

$(alwaysTimes): times/%.times: %/src/ccrypt run-trials $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< </dev/null >$@. 2>&1
	mv $@. $@

$(sampleTimes): times/sample-all-%.times: sample-all/src/ccrypt run-trials $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< $* </dev/null >$@. 2>&1
	mv $@. $@

fuzz := ../../fuzz/fuzz

$(seeds:%=inputs/%.noise): inputs/%.noise: $(fuzz)
	[ -d $(@D) ] || mkdir $(@D)
	$< $* 20 $@

$(fuzz): force
	$(MAKE) -C $(@D) $(@F)

force:
.PHONY: force

clean::
	rm -f collated-times.txt
	rm -rf inputs times

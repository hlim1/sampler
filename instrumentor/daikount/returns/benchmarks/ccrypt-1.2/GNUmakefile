builds := always-none always-all sample-all


########################################################################


all: pristine-stamp $(builds:=/src/ccrypt)

pristine-stamp: build-pristine always-none/src/ccrypt
	./$^
	touch $@

clean-local: $(builds:=/clean)
	rm -f pristine-stamp
	rm -rf cyphertext pristine

$(builds:=/src/ccrypt): %/ccrypt: %
	make -C $(dir $(@D))

$(builds:=/src):
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

times: $(times)

$(alwaysTimes): times/%.times: %/src/ccrypt $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< </dev/null >$@. 2>&1
	mv $@. $@

$(sampleTimes): times/sample-all-%.times: sample-all/src/ccrypt $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< $* </dev/null >$@. 2>&1
	mv $@. $@

inputs/%.noise: ../../../../../fuzz/fuzz
	[ -d $(@D) ] || mkdir $(@D)
	$< $* 4 $@

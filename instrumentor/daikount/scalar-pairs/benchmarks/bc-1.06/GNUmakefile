builds := always-none always-all sample-all


########################################################################


all: $(builds:=/bc/bc)

$(builds:=/bc/bc): %/bc: %
	make -C $(dir $(@D))

$(builds:=/bc):
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

collated-times.txt: collate-times $(times)
	./$< times >times/$@
	cp times/$@ $@

$(alwaysTimes): times/%.times: %/bc/bc run-trials $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< </dev/null >$@. 2>&1
	mv $@. $@

$(sampleTimes): times/sample-all-%.times: sample-all/bc/bc run-trials $(seeds:%=inputs/%.noise)
	[ -d $(@D) ] || mkdir $(@D)
	./run-trials $< $* </dev/null >$@. 2>&1
	mv $@. $@

inputs/%.noise: ../../../../../fuzz/fuzz
	[ -d $(@D) ] || mkdir $(@D)
	$< $* 9 $@

clean::
	rm -f collated-times.txt
	rm -rf inputs times

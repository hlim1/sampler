olden := bh bisort em3d health mst perimeter power treeadd tsp
spec95 := compress go ijpeg li
benchmarks := $(olden) $(spec95)

SUBDIRS := $(benchmarks)

recurse = $(MAKE) -C $(@D) $(@F)


basis := $(benchmarks:=/basis)
basis: $(basis)
.PHONY: basis
$(basis):
	+$(recurse)

loopless := $(benchmarks:=/loopless)
loopless: $(loopless)
.PHONY: loopless
$(loopless): force
	+$(recurse)

idents := $(benchmarks:=/idents)
idents: $(idents)
.PHONY: idents
$(idents): force
	+$(recurse)


########################################################################


times: collated-times.txt
.PHONY: times

collated-times.txt: $(benchmarks:=/times)
	./collate-times >$@.
	mv $@. $@

times := $(benchmarks:=/times)
$(times):
	+$(recurse)


########################################################################


stats: collated-stats.txt
.PHONY: stats

collated-stats.txt: collate-stats $(benchmarks:=/stats)
	./$^ >$@.
	mv $@. $@

stats := $(benchmarks:=/stats)
$(stats): force
	+$(recurse)


########################################################################


force:
.PHONY: force

.PHONY: $(benchmarks:=/%)

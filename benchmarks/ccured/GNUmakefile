olden := bh bisort em3d health mst perimeter power treeadd tsp
spec95 := compress go ijpeg li
benchmarks := $(sort $(olden) $(spec95))


recurse = $(MAKE) -C $(@D) $(@F)


all: $(benchmarks:=/all)
.PHONY: all
$(benchmarks:=/all):
	+$(recurse)

basis: $(benchmarks:=/basis)
.PHONY: basis
$(benchmarks:=/basis):
	+$(recurse)

loopless: $(benchmarks:=/loopless)
.PHONY: loopless
$(benchmarks:=/loopless): force
	+$(recurse)

idents: $(benchmarks:=/idents)
.PHONY: idents
$(benchmarks:=/idents): force
	+$(recurse)

clean: $(benchmarks:=/clean)
.PHONY: clean
$(benchmarks:=/clean): force
	+$(recurse)

spotless: $(benchmarks:=/spotless)
.PHONY: spotless
$(benchmarks:=/spotless): force
	+$(recurse)

GNUmakefile: config.mk
config.mk: %: ../../config.status %.in
	cd $(<D) && ./$(<F) benchmarks/ccured/$@


########################################################################


times: collated-times-all.txt collated-times-only.txt
.PHONY: times

collated-times-all.txt: $(benchmarks:=/times)
	./collate-times-all >$@.
	mv $@. $@

collated-times-only.txt: $(benchmarks:=/times)
	./collate-times-only >$@.
	mv $@. $@

$(benchmarks:=/times):
	+$(recurse)


########################################################################


stats: collated-stats.txt
.PHONY: stats

collated-stats.txt: collate-stats $(benchmarks:=/stats)
	./$^ >$@.
	mv $@. $@

$(benchmarks:=/stats): force
	+$(recurse)


########################################################################


force:
.PHONY: force

.PHONY: $(benchmarks:=/%)

0olden := bh bisort em3d health mst perimeter power treeadd tsp
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

times: $(benchmarks:=/times)
.PHONY: times
$(benchmarks:=/times):
	+$(recurse)

stats: $(benchmarks:=/stats)
.PHONY: stats
$(benchmarks:=/stats): force
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
config.mk: %: ../../../config.status %.in
	cd ../../.. && ./config.status instrumentor/decure/benchmarks/config.mk

collated-times.txt: times
	./collate-times >$@.
	mv $@. $@

force:
.PHONY: force

.PHONY: $(benchmarks:=/%)

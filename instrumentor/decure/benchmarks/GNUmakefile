olden := bh bisort em3d health mst perimeter power treeadd tsp
spec95 := compress go ijpeg li
benchmarks := $(strip $(olden) $(spec95))


recurse = $(MAKE) -C $(@D) $(@F)


all: $(benchmarks:=/all)
.PHONY: all
$(benchmarks:=/all):
	$(recurse)

basis: $(benchmarks:=/basis)
.PHONY: basis
$(benchmarks:=/basis):
	$(recurse)

times: $(benchmarks:=/times)
.PHONY: times
$(benchmarks:=/times):
	$(recurse)

loopless: $(benchmarks:=/loopless)
.PHONY: loopless
$(benchmarks:=/loopless): force
	$(recurse)

clean: $(benchmarks:=/clean)
.PHONY: clean
$(benchmarks:=/clean): force
	$(recurse)

spotless: $(benchmarks:=/spotless)
.PHONY: spotless
$(benchmarks:=/spotless): force
	$(recurse)

force:
.PHONY: force

.PHONY: $(benchmarks:=/%)

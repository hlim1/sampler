dir := ../../instrumentor/decure/benchmarks

olden := bh bisort em3d health mst perimeter power treeadd tsp
spec95 := compress go ijpeg li


########################################################################


all::static
static: olden-static.tex spec95-static.tex

olden_static := $(patsubst %, $(dir)/%/stats, $(olden))
olden-static.tex: ccured-static.pl $(olden_static)
	./$^ >$@ || rm -f $@
	@[ -r $@ ]

spec95_static := $(patsubst %, $(dir)/%/stats, $(spec95))
spec95-static.tex: ccured-static.pl $(spec95_static)
	./$^ >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


sparsities := 100 10000 1000000


all::density
density: olden-density.tex spec95-density.tex

olden_density := $(foreach bench, $(olden), $(foreach sparse, $(sparsities), $(dir)/$(bench)/$(sparse).times))
olden-density.tex : ccured-density.pl $(olden_density)
	./$< $(patsubst %, $(dir)/%, $(olden)) >$@ || rm -f $@
	@[ -r $@ ]

spec95_density := $(foreach bench, $(spec95), $(foreach sparse, $(sparsities), $(dir)/$(bench)/$(sparse).times))
spec95-density.tex : ccured-density.pl $(spec95_density)
	./$< $(patsubst %, $(dir)/%, $(spec95)) >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


all:: perimeter.eps

perimeter.eps: decure-only-one-function.sxc
	$(error please re-export $@ from $<)

ccured := $(benchdir)/ccured


########################################################################


all: ccured-static.tex

ccured-static.tex: %.tex: %.pl $(ccured)/collated-stats.txt
	./$^ >$@.
	mv $@. $@

spec95_static := $(patsubst %, $(ccured)/%/stats, $(spec95))
spec95-static.tex: ccured-static.pl $(spec95_static)
	./$^ >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


all: ccured-density.tex

ccured-density.tex: %.tex: %.pl $(ccured)/collated-times-all.txt
	./$^ >$@.
	mv $@. $@


########################################################################


all: ccured-size.tex

ccured-size.tex: %.tex: %.pl $(ccured)/collated-times-all.txt
	./$< >$@.
	mv $@. $@


########################################################################


all: $(addprefix perimeter., eps pdf)

decure-only-one-function.sxc: collated-times.txt
	$(error please refresh $< in $@)

perimeter.eps: decure-only-one-function.sxc
	$(error please re-export $@ from $<)

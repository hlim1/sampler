ccured := $(benchdir)/ccured


########################################################################


tex += ccured-static

ccured-static.tex: %.tex: %.pl $(ccured)/collated-stats.txt
	./$^ >$@.
	mv $@. $@

spec95_static := $(patsubst %, $(ccured)/%/stats, $(spec95))
spec95-static.tex: ccured-static.pl $(spec95_static)
	./$^ >$@ || rm -f $@
	@[ -r $@ ]


########################################################################


tex += ccured-density

ccured-density.tex: %.tex: %.pl $(ccured)/collated-times-all.txt
	./$^ >$@.
	mv $@. $@


########################################################################


tex += ccured-size

ccured-size.tex: %.tex: %.pl $(ccured)/collated-times-all.txt
	./$< >$@.
	mv $@. $@


########################################################################


eps += perimeter

decure-only-one-function.sxc: collated-times.txt
	$(error please refresh $< in $@)

perimeter.eps: decure-only-one-function.sxc
	$(error please re-export $@ from $<)

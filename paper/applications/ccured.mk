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

ccured-density.tex: %.tex: %.pl $(ccured)/collated-times.txt
	./$^ >$@.
	mv $@. $@

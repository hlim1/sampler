eps += ds1000ngood_plot

ds1000ngood_plot.eps: %.eps: ngood_plot.m %.mat
	rm -f $@
	$(matlab) -r $(basename $<)
	[ -r $@ ]


########################################################################


dir := $(benchdir)/ccrypt-1.2


eps += ccrypt_density

ccrypt_density.txt: density.pl $(dir)/collated-times.txt
	./$^ >$@.
	mv $@. $@

ccrypt_density.eps: %.eps: %.m %.txt
	rm -f $@
	$(matlab) -r $*
	[ -r $@ ]

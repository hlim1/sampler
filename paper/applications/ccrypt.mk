eps += ds1000ngood_plot

ds1000ngood_plot.eps: %.eps: ngood_plot.m %.mat
	rm -f $@
	$(matlab) -r $(basename $<)
	[ -r $@ ]

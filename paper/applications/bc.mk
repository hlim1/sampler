bc := $(benchdir)/bc-1.06


########################################################################


eps += bc_density

bc_density.txt: %.txt: %.pl $(bc)/collated-times.txt
	./$^ >$@.
	mv $@. $@

bc_density.eps: %.eps: %.m %.txt
	rm -f $@
	$(matlab) -r $*
	[ -r $@ ]
